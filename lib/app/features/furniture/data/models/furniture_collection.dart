import 'furniture_model.dart';

class FurnitureCollection {
  final List<FurnitureModel> data;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final bool hasNext;
  final bool hasPrevious;

  const FurnitureCollection({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory FurnitureCollection.fromJson(Map<String, dynamic> json) {
    return FurnitureCollection(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => FurnitureModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrevious: json['hasPrevious'] as bool? ?? false,
    );
  }

  bool get isEmpty => data.isEmpty;
}
