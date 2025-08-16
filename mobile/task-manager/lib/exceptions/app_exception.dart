class AppException implements Exception {
  final String message;
  final int? code; // opcional, para códigos HTTP u otros

  AppException(this.message, {this.code});

  @override
  String toString() => message;
}
