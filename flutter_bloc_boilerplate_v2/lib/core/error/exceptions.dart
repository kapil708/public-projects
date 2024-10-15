class RemoteException implements Exception {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? errors;

  RemoteException({
    required this.statusCode,
    required this.message,
    this.errors,
  });
}
