import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/constants/constantes.dart';

import 'residence_model.dart';

part 'residences_collection.freezed.dart';
part 'residences_collection.g.dart';

@freezed
class ResidencesCollection with _$ResidencesCollection {
  factory ResidencesCollection({
    @Default([]) List<ResidenceModel>? data,
    @JsonKey(fromJson: toInt) int? currentPage,
    @JsonKey(fromJson: toInt) int? totalPages,
    @JsonKey(fromJson: toInt) int? pageSize,
    @Default(false) bool? hasNext,
    @Default(false) bool? hasPrevious,
  }) = _ResidencesCollection;

  factory ResidencesCollection.fromJson(Map<String, dynamic> json) =>
      _$ResidencesCollectionFromJson(json);
}
