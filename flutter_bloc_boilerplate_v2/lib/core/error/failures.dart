class RemoteFailure {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? errors;

  const RemoteFailure({
    required this.statusCode,
    required this.message,
    this.errors,
  });
}
