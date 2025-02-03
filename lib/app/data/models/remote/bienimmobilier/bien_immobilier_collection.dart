import 'package:freezed_annotation/freezed_annotation.dart';

import 'bien_immobilier_model.dart';

part 'bien_immobilier_collection.freezed.dart';
part 'bien_immobilier_collection.g.dart';

@freezed
class BienImmobilierCollection with _$BienImmobilierCollection {
  factory BienImmobilierCollection({
    @Default([]) List<BienImmobilierModel>? data,
    @Default(0) int? currentPage,
    @Default(0) int? totalPages,
    @Default(0) int? pageSize,
    @Default(false) bool? hasNext,
    @Default(false) bool? hasPrevious,
  }) = _BienImmobilierCollection;

  factory BienImmobilierCollection.fromJson(Map<String, dynamic> json) =>
      _$BienImmobilierCollectionFromJson(json);
}
