class ApiConfig {
  String? baseUrl;
  Duration? connectTimeout;
  Duration? receiveTimeout;
  Map<String, dynamic>? headers;
  bool? showLogs;

  ApiConfig({
    this.baseUrl,
    this.connectTimeout,
    this.receiveTimeout,
    this.headers,
    this.showLogs = true,
  });
}
