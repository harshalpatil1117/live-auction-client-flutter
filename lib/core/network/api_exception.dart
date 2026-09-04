/// Categorizes failures so the presentation layer can react appropriately
/// (e.g. show a retry button for [timeout]/[server], or a specific offline
/// message for [network]) without knowing anything about Dio.
enum ApiErrorType { network, timeout, server, parsing, unknown }

class ApiException implements Exception {
  final ApiErrorType type;
  final String message;

  const ApiException(this.type, this.message);

  @override
  String toString() => message;
}
