/// Les 6 onglets de la grille de l'accueil.
enum HomeGridTab {
  stay('sejour'),
  rent('logement'),
  hotel('hotel'),
  buy('bien'),
  map('carte'),
  move('demenager');

  const HomeGridTab(this.analyticsValue);

  final String analyticsValue;
}
