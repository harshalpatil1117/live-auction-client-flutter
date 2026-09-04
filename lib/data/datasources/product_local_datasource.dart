import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../core/database/database_helper.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  /// Returns null if this query has never been cached — distinct from an
  /// empty list, which means it *was* searched before and legitimately
  /// returned no results.
  Future<List<Product>?> getCachedSearch(String query);

  Future<void> cacheSearch(String query, List<Product> products);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final DatabaseHelper _dbHelper;

  ProductLocalDataSourceImpl(this._dbHelper);

  // Cache key is normalized so "Phone", " phone ", and "PHONE" share one
  // cache entry instead of three.
  String _normalize(String query) => query.trim().toLowerCase();

  @override
  Future<List<Product>?> getCachedSearch(String query) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'search_cache',
      where: 'query = ?',
      whereArgs: [_normalize(query)],
    );

    if (rows.isEmpty) return null;

    final raw = rows.first['results'] as String;
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheSearch(String query, List<Product> products) async {
    final db = await _dbHelper.database;
    await db.insert(
      'search_cache',
      {
        'query': _normalize(query),
        'results': jsonEncode(products.map((p) => p.toJson()).toList()),
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
