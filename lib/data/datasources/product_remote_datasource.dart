import 'package:dio/dio.dart';

import '../../core/network/api_exception.dart';
import '../models/product_model.dart';
import '../models/product_page.dart';

abstract class ProductRemoteDataSource {
  Future<ProductPage> getProducts({required int limit, required int skip});
  Future<List<Product>> searchProducts(String query);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio _dio;

  ProductRemoteDataSourceImpl(this._dio);

  @override
  Future<ProductPage> getProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: {'limit': limit, 'skip': skip},
      );
      return ProductPage.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        ApiErrorType.parsing,
        'Received an unexpected response while loading products.',
      );
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _dio.get(
        '/products/search',
        queryParameters: {'q': query},
      );
      final page = ProductPage.fromJson(response.data as Map<String, dynamic>);
      return page.products;
    } on DioException catch (e) {
      throw _mapDioException(e);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        ApiErrorType.parsing,
        'Received an unexpected response while searching.',
      );
    }
  }

  ApiException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(ApiErrorType.timeout, 'Request timed out.');
      case DioExceptionType.connectionError:
        return const ApiException(
          ApiErrorType.network,
          'No internet connection.',
        );
      case DioExceptionType.badResponse:
        return ApiException(
          ApiErrorType.server,
          'Server error (${e.response?.statusCode}).',
        );
      default:
        return ApiException(
          ApiErrorType.unknown,
          e.message ?? 'Unexpected network error.',
        );
    }
  }
}
