import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/configs/ville_model.dart';

part 'ville_collection.freezed.dart';
part 'ville_collection.g.dart';

@freezed
class VilleCollection with _$VilleCollection {
  factory VilleCollection({
    @Default([]) List<VilleModel>? data,
    @Default(1) int currentPage,
    @Default(1) int totalPages,
    @Default(10) int pageSize,
    @Default(0) int totalCount,
    @Default(false) bool hasNext,
    @Default(false) bool hasPrevious,
  }) = _VilleCollection;

  factory VilleCollection.fromJson(Map<String, dynamic> json) =>
      _$VilleCollectionFromJson(json);
}
