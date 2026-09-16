/// `availabilityPreset` — alternative à `availabilityDate` : le serveur
/// calcule la date (aujourd'hui / +2 semaines / 1er jour du mois prochain).
enum RelaisAvailabilityPreset {
  immediate('immediate', 'Dès maintenant'),
  twoWeeks('two_weeks', 'Dans 2 semaines'),
  nextMonth('next_month', 'Le mois prochain');

  final String value;
  final String label;

  const RelaisAvailabilityPreset(this.value, this.label);
}
