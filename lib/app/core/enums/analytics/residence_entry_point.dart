/// Zone de l'application depuis laquelle une fiche résidence est ouverte.
/// Transmis à la fiche (query `entry_point`) puis aux événements du funnel
/// de réservation (consultation, CTA, checkout).
enum ResidenceEntryPoint {
  search('search'),
  homeFeed('home_feed'),
  nearMe('near_me'),
  map('map'),
  alert('alert');

  const ResidenceEntryPoint(this.analyticsValue);

  final String analyticsValue;

  static const queryKey = 'entry_point';

  static ResidenceEntryPoint? fromValue(String? value) {
    for (final entryPoint in values) {
      if (entryPoint.analyticsValue == value) return entryPoint;
    }
    return null;
  }
}
