enum FilterKind {
  select('select'),
  priceRange('price_range'),
  minCount('min_count'),
  dateRange('date_range');

  final String value;

  const FilterKind(this.value);

  bool get isSelect => this == FilterKind.select;
  bool get isPriceRange => this == FilterKind.priceRange;
  bool get isMinCount => this == FilterKind.minCount;
  bool get isDateRange => this == FilterKind.dateRange;

  static FilterKind fromValue(String? value) {
    if (value?.toLowerCase() == 'count') return FilterKind.minCount;

    return FilterKind.values.firstWhere(
      (e) => e.value.toLowerCase() == value?.toLowerCase(),
      orElse: () => FilterKind.select,
    );
  }
}
