class ApiException implements Exception {
  final int statusCode;
  final String? message;
  final dynamic data;

  ApiException({
    required this.statusCode,
    this.message,
    this.data,
  });
}
