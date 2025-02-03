class PhoneNumberHandler {
  /// Formate un numéro de téléphone en supprimant le '+' au début, s'il est présent.
  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('+')) {
      return phoneNumber.substring(1); // Supprime le premier caractère.
    }
    return phoneNumber;
  }
}
