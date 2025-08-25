import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/constants/constantes.dart';

import 'bien_immobilier_model.dart';

part 'bien_immobilier_collection.freezed.dart';
part 'bien_immobilier_collection.g.dart';

@freezed
class BienImmobilierCollection with _$BienImmobilierCollection {
  factory BienImmobilierCollection({
    @Default([]) List<BienImmobilierModel>? data,
    @JsonKey(fromJson: toInt) int? currentPage,
    @JsonKey(fromJson: toInt) int? totalPages,
    @JsonKey(fromJson: toInt) int? pageSize,
    @Default(false) bool? hasNext,
    @Default(false) bool? hasPrevious,
  }) = _BienImmobilierCollection;

  factory BienImmobilierCollection.fromJson(Map<String, dynamic> json) =>
      _$BienImmobilierCollectionFromJson(json);
}
