class AddressException implements Exception {
  String? _message;

  AddressException(
      [String message =
          "Une erreur s'est produite lors de la détection de l'adresse. Veuillez réessayer."]) {
    _message = message;
  }

  @override
  String toString() {
    return _message!;
  }
}
