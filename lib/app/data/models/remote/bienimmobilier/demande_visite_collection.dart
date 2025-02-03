import 'package:freezed_annotation/freezed_annotation.dart';

import 'demande_visite_model.dart';

part 'demande_visite_collection.freezed.dart';
part 'demande_visite_collection.g.dart';

@freezed
class DemandeVisiteCollection with _$DemandeVisiteCollection {
  factory DemandeVisiteCollection({
    @Default([]) List<DemandeVisiteModel>? data,
    @Default(0) int currentPage,
    @Default(0) int totalPages,
    @Default(0) int pageSize,
    @Default(0) int totalCount,
    @Default(false) bool hasPrevious,
    @Default(false) bool hasNext,
  }) = _DemandeVisiteCollection;

  factory DemandeVisiteCollection.fromJson(Map<String, dynamic> json) =>
      _$DemandeVisiteCollectionFromJson(json);
}
