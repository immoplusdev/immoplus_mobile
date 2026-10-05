enum FilterKind {
  select('select'),
  priceRange('price_range'),
  minCount('min_count');

  final String value;

  const FilterKind(this.value);

  bool get isSelect => this == FilterKind.select;
  bool get isPriceRange => this == FilterKind.priceRange;
  bool get isMinCount => this == FilterKind.minCount;

  static FilterKind fromValue(String? value) {
    return FilterKind.values.firstWhere(
      (e) => e.value.toLowerCase() == value?.toLowerCase(),
      orElse: () => FilterKind.select,
    );
  }
}
