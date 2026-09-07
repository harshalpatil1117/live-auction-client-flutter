import 'dart:async';

import '../../core/network/api_exception.dart';
import '../../core/network/connectivity_service.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';
import '../models/product_page.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remote;
  final ProductLocalDataSource _local;
  final ConnectivityService _connectivity;

  ProductRepositoryImpl(this._remote, this._local, this._connectivity);

  @override
  Future<ProductPage> getProducts({
    required int limit,
    required int skip,
  }) {
    return _remote.getProducts(limit: limit, skip: skip);
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final online = await _connectivity.isOnline;

    if (!online) {
      final cached = await _local.getCachedSearch(query);
      if (cached != null) return cached;
      throw ApiException(
        ApiErrorType.network,
        'No internet connection, and "$query" hasn\'t been searched before.',
      );
    }

    try {
      final results = await _remote.searchProducts(query);
      unawaited(_local.cacheSearch(query, results));
      return results;
    } on ApiException {
      final cached = await _local.getCachedSearch(query);
      if (cached != null) return cached;
      rethrow;
    }
  }
}
