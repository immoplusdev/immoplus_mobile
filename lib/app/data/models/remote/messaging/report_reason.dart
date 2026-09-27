/// Motifs de signalement d'une conversation (spec §7.1), mappés aux valeurs
/// attendues par `POST /conversations/:id/report`.
enum ReportReason {
  contactInfoAttempt('contact_info_attempt', 'Tentative de partage de coordonnées'),
  offPlatformTransactionAttempt(
      'off_platform_transaction_attempt', 'Tentative de paiement hors ImmoPlus'),
  harassment('harassment', 'Comportement harcelant'),
  spam('spam', 'Spam'),
  scam('scam', 'Arnaque'),
  other('other', 'Autre');

  final String value;
  final String label;
  const ReportReason(this.value, this.label);
}
