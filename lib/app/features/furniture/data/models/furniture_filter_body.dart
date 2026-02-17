class FurnitureFilterBody {
  final int page;
  final String? search;
  final String? category;
  final String? type;
  final int? minPrice;
  final int? maxPrice;

  const FurnitureFilterBody({
    this.page = 1,
    this.search,
    this.category,
    this.type,
    this.minPrice,
    this.maxPrice,
  });

  FurnitureFilterBody copyWith({
    int? page,
    String? search,
    String? category,
    String? type,
    int? minPrice,
    int? maxPrice,
  }) {
    return FurnitureFilterBody(
      page: page ?? this.page,
      search: search ?? this.search,
      category: category ?? this.category,
      type: type ?? this.type,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> query = {'page': page};
    if (search != null && search!.isNotEmpty) query['search'] = search;
    if (category != null && category!.isNotEmpty) query['category'] = category;
    if (type != null && type!.isNotEmpty) query['type'] = type;
    if (minPrice != null) query['minPrice'] = minPrice;
    if (maxPrice != null) query['maxPrice'] = maxPrice;
    return query;
  }
}
