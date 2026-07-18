enum HomeTab {
  residence(0),
  hotel(1),
  location(2),
  furniture(3),
  bien(4);

  final int value;
  const HomeTab(this.value);

  String? get category => switch (this) {
        HomeTab.residence => 'residence',
        HomeTab.hotel => 'hotel',
        HomeTab.location => 'location',
        HomeTab.bien => 'bien',
        _ => null,
      };

  String get label => switch (this) {
        HomeTab.residence => 'Résidences',
        HomeTab.hotel => 'Hôtel',
        HomeTab.location => 'Location',
        HomeTab.furniture => 'Meubles',
        HomeTab.bien => 'Biens',
      };

  String get imagePath => switch (this) {
        HomeTab.residence => 'assets/img/menu_residence.jpg',
        HomeTab.hotel => 'assets/img/menu_hotel_1.jpg',
        HomeTab.location => 'assets/img/menu_location.png',
        HomeTab.furniture => 'assets/img/menu_meubles.jpg',
        HomeTab.bien => 'assets/img/menu_biens.jpg',
      };
}
