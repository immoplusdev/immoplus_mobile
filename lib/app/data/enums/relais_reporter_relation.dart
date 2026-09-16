/// `reporterRelation` — flux B (signalement anonyme) uniquement. Présent =
/// flux B, absent = flux A (occupant déclare son propre logement).
enum RelaisReporterRelation {
  occupant(
    'occupant',
    "J'y habitais",
    'Vous quittez ce logement, qui reste libre',
  ),
  neighbor(
    'neighbor',
    'Je suis un voisin',
    'Vous savez que le logement est vacant',
  ),
  other(
    'other',
    'Autre lien',
    'Précisez dans le message ci-dessus',
  );

  final String value;
  final String label;
  final String description;

  const RelaisReporterRelation(this.value, this.label, this.description);
}
