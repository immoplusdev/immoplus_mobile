import 'package:freezed_annotation/freezed_annotation.dart';

part 'relais_update_request.freezed.dart';
part 'relais_update_request.g.dart';

/// Body de `PATCH /relais/:id` (voir `update-immo-relais.dto.ts`) — tous
/// les champs sont optionnels, seuls ceux fournis sont modifiés. Le
/// `toJson()` généré inclut les champs `null` : c'est `RelaisRepository.
/// updateRelais()` qui les retire avant l'envoi (`includeIfNull: false`
/// au niveau classe entre en conflit avec `@freezed` — double génération
/// de `_$RelaisUpdateRequestFromJson` dans `.freezed.dart` ET `.g.dart`).
///
/// `status` n'accepte réellement que `"matching"` côté serveur (seule
/// transition autorisée depuis `upcoming` — `ALLOWED_TRANSITIONS`), donc
/// volontairement jamais renseigné par l'écran d'édition générique.
@freezed
class RelaisUpdateRequest with _$RelaisUpdateRequest {
  const factory RelaisUpdateRequest({
    String? propertyType,
    String? location,
    String? landmark,
    double? latitude,
    double? longitude,
    int? currentRentPrice,
    int? rooms,
    int? surface,
    String? approximateDepartureDate,
    String? availabilityDate,
    String? availabilityPreset,
    String? reason,
    String? additionalNotes,
    String? status,
    String? reporterRelation,
    String? reporterRelationDetails,
    List<String>? photos,
    List<String>? extras,
  }) = _RelaisUpdateRequest;

  factory RelaisUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$RelaisUpdateRequestFromJson(json);
}
