class ErrorRequestException implements Exception {
  String message;
  ErrorRequestException({required this.message});

  @override
  String toString() {
    return message;
  }
}
