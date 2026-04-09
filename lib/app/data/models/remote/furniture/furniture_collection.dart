import 'package:freezed_annotation/freezed_annotation.dart';
import 'furniture_model.dart';

part 'furniture_collection.freezed.dart';
part 'furniture_collection.g.dart';

@freezed
class FurnitureCollection with _$FurnitureCollection {
  const factory FurnitureCollection({
    @Default([]) List<FurnitureModel>? data,
    int? currentPage,
    int? totalPages,
    int? pageSize,
    int? totalCount,
    @Default(false) bool? hasNext,
    @Default(false) bool? hasPrevious,
  }) = _FurnitureCollection;

  factory FurnitureCollection.fromJson(Map<String, dynamic> json) =>
      _$FurnitureCollectionFromJson(json);
}
