class PhoneNumberHandler {
  /// Formate un numéro de téléphone en supprimant le '+' au début, s'il est présent.
  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('+')) {
      return phoneNumber.substring(1); // Supprime le premier caractère.
    }
    return phoneNumber;
  }

  /// Supprime l'indicatif (avec ou sans le '+') d'un numéro de téléphone.
  /// Par défaut, l'indicatif est '225'.
  /// Le paramètre [removePlus] permet de décider si on souhaite retirer le '+' du début du numéro final (par défaut true).
  static String removeDialCode(
    String phoneNumber, {
    String dialCode = '225',
    bool removePlus = true,
  }) {
    String cleanNumber = phoneNumber.trim();
    String cleanDial = dialCode.trim();

    // Supprimer le '+' au début de l'indicatif s'il est présent
    if (cleanDial.startsWith('+')) {
      cleanDial = cleanDial.substring(1);
    }

    // 1. Si le numéro commence par '+' + indicatif (ex: "+2250455...")
    if (cleanNumber.startsWith('+$cleanDial')) {
      final rest = cleanNumber.substring(1 + cleanDial.length);
      return removePlus ? rest : '+$rest';
    }

    // 2. Si le numéro commence par l'indicatif propre (ex: "2250455...")
    if (cleanNumber.startsWith(cleanDial)) {
      return cleanNumber.substring(cleanDial.length);
    }

    // 3. Si le numéro commence par '+' (ex: "+0455...") et removePlus est vrai
    if (removePlus && cleanNumber.startsWith('+')) {
      return cleanNumber.substring(1);
    }

    return cleanNumber;
  }
}
