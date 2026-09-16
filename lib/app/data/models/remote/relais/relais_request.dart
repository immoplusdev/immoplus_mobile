import 'package:freezed_annotation/freezed_annotation.dart';

part 'relais_request.freezed.dart';
part 'relais_request.g.dart';

/// Body de `POST /relais` — flux B (signalement anonyme) : `reporterRelation`
/// présent. Les champs loyer/surface/date de départ/raison du flux A
/// (occupant) ne sont pas exposés ici, pas nécessaires pour ce flux.
@freezed
class RelaisRequest with _$RelaisRequest {
  const factory RelaisRequest({
    required String propertyType,
    required String location,
    String? landmark,
    required int rooms,
    required String reporterRelation,
    String? reporterRelationDetails,
    String? availabilityDate,
    String? availabilityPreset,
    @Default([]) List<String> photos,
  }) = _RelaisRequest;

  factory RelaisRequest.fromJson(Map<String, dynamic> json) =>
      _$RelaisRequestFromJson(json);
}
