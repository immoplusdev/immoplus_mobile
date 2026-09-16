import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/enums/immo_relais_status.dart';

part 'relais_model.freezed.dart';
part 'relais_model.g.dart';

/// Un seul modèle pour les 3 formes de réponse de la doc (elles ne sont
/// que des sous/sur-ensembles les unes des autres — les champs absents
/// d'une forme restent simplement `null`) :
/// - `POST /relais` (création, flux B)
/// - `GET /relais` (liste — items allégés, pas de `occupantId`/`propertyId`/
///   `latitude`/`longitude`/`updatedAt`)
/// - `GET /relais/:id` (détail complet)
@freezed
class RelaisModel with _$RelaisModel {
  const RelaisModel._();

  const factory RelaisModel({
    required String id,
    String? occupantId,
    String? propertyId,
    required String propertyType,
    required String location,
    String? landmark,
    double? latitude,
    double? longitude,
    int? currentRentPrice,
    required int rooms,
    int? surface,
    String? approximateDepartureDate,
    DateTime? availabilityDate,
    String? reason,
    String? reporterRelation,
    String? reporterRelationDetails,
    String? additionalNotes,
    @Default([]) List<String> photos,
    @Default([]) List<String> extras,
    required String status,
    String? matchingStatus,
    @Default(0) int interestedCount,
    @Default(0) int potentialMatches,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RelaisModel;

  factory RelaisModel.fromJson(Map<String, dynamic> json) =>
      _$RelaisModelFromJson(json);

  ImmoRelaisStatus get statusEnum => ImmoRelaisStatus.fromString(status);
}
