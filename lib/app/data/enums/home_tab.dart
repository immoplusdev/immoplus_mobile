enum HomeTab {
  forYou(0),
  residence(1),
  hotel(2),
  location(3),
  furniture(4),
  bien(5);

  final int value;
  const HomeTab(this.value);

  static List<HomeTab> get valuestabs => [
        HomeTab.forYou,
        HomeTab.residence,
        HomeTab.location,
        // HomeTab.furniture,
        HomeTab.bien,
        HomeTab.hotel,
      ];

  String? get category => switch (this) {
        HomeTab.residence => 'residence',
        HomeTab.hotel => 'hotel',
        HomeTab.location => 'location',
        HomeTab.bien => 'bien',
        _ => null,
      };

  String get label => switch (this) {
        HomeTab.forYou => 'Pour vous',
        HomeTab.residence => 'Résidences',
        HomeTab.hotel => 'Hôtel',
        HomeTab.location => 'Location',
        HomeTab.furniture => 'Meubles',
        HomeTab.bien => 'Biens',
      };

  String get imagePath => switch (this) {
        HomeTab.forYou => 'assets/img/menu_residence.jpg',
        HomeTab.residence => 'assets/img/menu_residence.jpg',
        HomeTab.hotel => 'assets/img/menu_hotel_1.jpg',
        HomeTab.location => 'assets/img/menu_location.png',
        HomeTab.furniture => 'assets/img/menu_meubles.jpg',
        HomeTab.bien => 'assets/img/menu_biens.jpg',
      };
}
