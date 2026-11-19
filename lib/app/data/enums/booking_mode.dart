/// Mode de réservation du client, décidé par le serveur (jamais déduit côté
/// app) : `PAY_NOW` / `INSTANT` = paiement direct (« Payer »), `REQUEST` =
/// demande au propriétaire (« Réserver »).
enum BookingMode {
  payNow('PAY_NOW'),
  request('REQUEST');

  const BookingMode(this.value);

  final String value;

  /// Libellé des boutons d'action de réservation.
  String get ctaLabel => this == payNow ? 'Payer' : 'Réserver';

  /// Convertit une valeur brute (`PAY_NOW`, `INSTANT`, `REQUEST`) en [BookingMode],
  /// ou retourne `null` si la valeur est absente/inconnue.
  static BookingMode? tryFromValue(String? value) {
    final normalized = value?.trim().toUpperCase();
    if (normalized == null || normalized.isEmpty) return null;
    if (normalized == 'PAY_NOW' || normalized == 'INSTANT') {
      return BookingMode.payNow;
    }
    if (normalized == 'REQUEST') {
      return BookingMode.request;
    }
    return null;
  }

  /// Valeur inconnue ou absente : `REQUEST`, le comportement historique.
  static BookingMode fromValue(String? value) =>
      tryFromValue(value) ?? BookingMode.request;

  /// Résout le mode de réservation d'une résidence :
  /// - Si `residenceBookingMode` est fourni (`INSTANT` / `REQUEST`), il s'applique.
  /// - S'il est `null`, le `globalMode` issu de l'API globale s'affiche.
  static BookingMode resolve({
    String? residenceBookingMode,
    required BookingMode globalMode,
  }) =>
      tryFromValue(residenceBookingMode) ?? globalMode;
}
