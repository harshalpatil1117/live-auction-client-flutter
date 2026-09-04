import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Flutter-compatible equivalent of the "Room" requirement: sqflite is the
/// standard local relational database for Flutter (Room is Android-only and
/// doesn't exist outside the Android SDK). Kept as a plain singleton rather
/// than a repository itself — the datasource layer owns queries, this just
/// owns the connection and schema.
class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    return _db ??= await _initDb();
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'auction_cache.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // One row per search term, storing the full result set as JSON.
        // A normalized products/search-results join table would be more
        // "correct" relationally, but there's no query need for it here —
        // we only ever read back "all results for this exact query" — so
        // the simpler denormalized shape avoids pointless complexity.
        await db.execute('''
          CREATE TABLE search_cache (
            query TEXT PRIMARY KEY,
            results TEXT NOT NULL,
            cached_at INTEGER NOT NULL
          )
        ''');
      },
    );
  }
}
