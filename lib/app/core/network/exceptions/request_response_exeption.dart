class RequestResponseExeption implements Exception {
  final String message;
  RequestResponseExeption(this.message);
  @override
  String toString() => message;
}
