class AppException implements Exception {
  final String message;
  final int? code; // opcional: statusCode HTTP o código interno

  AppException(this.message, {this.code});

  @override
  String toString() => code != null ? '[$code] $message' : message;
}
