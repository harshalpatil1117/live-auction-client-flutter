import 'package:dio/dio.dart';

/// Just a configured Dio instance. Not wrapped in extra abstractions —
/// Dio itself is already the abstraction; the exception mapping that keeps
/// Dio out of the rest of the app happens in the remote data source.
class DioClient {
  DioClient._();

  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
}
