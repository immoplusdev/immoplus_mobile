import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';

part 'reverse_search_model.freezed.dart';
part 'reverse_search_model.g.dart';

@freezed
class ReverseSearchZone with _$ReverseSearchZone {
  const factory ReverseSearchZone({
    required String id,
    required String adresse,
    required double lat,
    required double lng,
  }) = _ReverseSearchZone;

  factory ReverseSearchZone.fromJson(Map<String, dynamic> json) =>
      _$ReverseSearchZoneFromJson(json);
}

@freezed
class ReverseSearchRequest with _$ReverseSearchRequest {
  const factory ReverseSearchRequest({
    required List<ReverseSearchZone> zones,
    required DateTime dateDebut,
    required DateTime dateFin,
    required int nombrePersonnes,
    required double budgetMin,
    required double budgetMax,
    String? notes,
  }) = _ReverseSearchRequest;

  factory ReverseSearchRequest.fromJson(Map<String, dynamic> json) =>
      _$ReverseSearchRequestFromJson(json);
}

@freezed
class ReverseSearchProposition with _$ReverseSearchProposition {
  const factory ReverseSearchProposition({
    required String reverseSearchId,
    required double montant,
    required ResidenceModel data,
  }) = _ReverseSearchProposition;

  factory ReverseSearchProposition.fromJson(Map<String, dynamic> json) =>
      _$ReverseSearchPropositionFromJson(json);
}
