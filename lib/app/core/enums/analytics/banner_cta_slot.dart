/// Bouton d'action d'une bannière (une bannière peut en porter deux).
enum BannerCtaSlot {
  primary('primary'),
  secondary('secondary');

  const BannerCtaSlot(this.analyticsValue);

  final String analyticsValue;
}
