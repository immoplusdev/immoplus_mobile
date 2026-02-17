import 'package:freezed_annotation/freezed_annotation.dart';
import 'furniture_model.dart';

part 'furniture_collection.freezed.dart';
part 'furniture_collection.g.dart';

@freezed
class FurnitureCollection with _$FurnitureCollection {
  const factory FurnitureCollection({
    @Default('') String message,
    @Default(false) bool status,
    int? count,
    int? total,
    @Default(false) bool hasNext,
    @Default([]) List<FurnitureModel>? data,
    int? currentPage,
    int? lastPage,
    int? perPage,
  }) = _FurnitureCollection;

  factory FurnitureCollection.fromJson(Map<String, dynamic> json) =>
      _$FurnitureCollectionFromJson(json);
}
