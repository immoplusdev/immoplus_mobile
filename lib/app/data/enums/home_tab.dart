enum HomeTab {
  residence(0),
  location(1),
  furniture(2),
  bien(3);

  final int value;
  const HomeTab(this.value);

  String? get category => switch (this) {
        HomeTab.residence => 'residence',
        HomeTab.location => 'location',
        HomeTab.bien => 'bien',
        _ => null,
      };

  String get label => switch (this) {
        HomeTab.residence => 'Résidences',
        HomeTab.location => 'Locations',
        HomeTab.furniture => 'Meubles',
        HomeTab.bien => 'Biens',
      };

  String get imagePath => switch (this) {
        HomeTab.residence => 'assets/img/menu_residence.jpg',
        HomeTab.location => 'assets/img/menu_location.png',
        HomeTab.furniture => 'assets/img/menu_meubles.jpg',
        HomeTab.bien => 'assets/img/menu_biens.jpg',
      };
}
