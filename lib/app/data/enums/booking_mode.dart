/// Mode de réservation du client, décidé par le serveur (jamais déduit côté
/// app) : `PAY_NOW` = paiement direct (« Payer »), `REQUEST` = demande au
/// propriétaire (« Réserver »).
enum BookingMode {
  payNow('PAY_NOW'),
  request('REQUEST');

  const BookingMode(this.value);

  final String value;

  /// Libellé des boutons d'action de réservation.
  String get ctaLabel => this == payNow ? 'Payer' : 'Réserver';

  /// Valeur inconnue ou absente : `REQUEST`, le comportement historique.
  static BookingMode fromValue(String? value) => BookingMode.values.firstWhere(
        (mode) => mode.value == value,
        orElse: () => BookingMode.request,
      );
}
