extension MonogramExtension on String {
  /// Extrait les initiales (max 2 lettres).
  /// Ex: "Marc Ephrem" → "ME", "Jean" → "J"
  String get initials {
    if (trim().isEmpty) return '?';

    final words = trim().split(RegExp(r'\s+'));

    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }

    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  /// Hash déterministe basé sur le nom pour choisir la couleur.
  int get colorHash {
    if (isEmpty) return 0;
    return codeUnits.fold(0, (prev, curr) => prev + curr);
  }
}
