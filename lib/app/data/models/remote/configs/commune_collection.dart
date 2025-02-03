import 'package:freezed_annotation/freezed_annotation.dart';

import 'commune_model.dart';

part 'commune_collection.freezed.dart';
part 'commune_collection.g.dart';

@freezed
class CommuneCollection with _$CommuneCollection {
  factory CommuneCollection({
    @Default([]) List<CommuneModel> data,
    @Default(1) int currentPage,
    @Default(1) int totalPages,
    @Default(10) int pageSize,
    @Default(0) int totalCount,
    @Default(false) bool hasNext,
    @Default(false) bool hasPrevious,
  }) = _CommuneCollection;

  factory CommuneCollection.fromJson(Map<String, dynamic> json) =>
      _$CommuneCollectionFromJson(json);
}
