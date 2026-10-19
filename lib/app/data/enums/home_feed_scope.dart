enum HomeFeedScope {
  rent('rent', 'Trouver un Logement'),
  buy('buy', 'Acheter un Bien'),
  stay('stay', 'Trouver un Séjour');

  final String value;
  final String defaultTitle;

  const HomeFeedScope(this.value, this.defaultTitle);

  bool get isStay => this == HomeFeedScope.stay;
  bool get isRent => this == HomeFeedScope.rent;
  bool get isBuy => this == HomeFeedScope.buy;

  static HomeFeedScope fromValue(String? value) {
    return HomeFeedScope.values.firstWhere(
      (e) => e.value.toLowerCase() == value?.toLowerCase(),
      orElse: () => HomeFeedScope.rent,
    );
  }
}
