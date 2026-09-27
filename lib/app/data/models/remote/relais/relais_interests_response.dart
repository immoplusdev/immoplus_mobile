import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/enums/relais_interest_status.dart';

part 'relais_interests_response.freezed.dart';
part 'relais_interests_response.g.dart';

/// Réponse de `GET /relais/:id/interests`
/// (`get-immo-relais-interests-query.handler.ts`) — pas de pagination, pas
/// de filtre `status` côté serveur malgré ce que suggérait la doc
/// initiale.
@freezed
class RelaisInterestsResponse with _$RelaisInterestsResponse {
  const factory RelaisInterestsResponse({
    required RelaisInterestsData data,
  }) = _RelaisInterestsResponse;

  factory RelaisInterestsResponse.fromJson(Map<String, dynamic> json) =>
      _$RelaisInterestsResponseFromJson(json);
}

@freezed
class RelaisInterestsData with _$RelaisInterestsData {
  const factory RelaisInterestsData({
    required String relaisId,
    @Default(0) int totalInterested,
    @Default([]) List<RelaisInterestModel> interestedParties,
  }) = _RelaisInterestsData;

  factory RelaisInterestsData.fromJson(Map<String, dynamic> json) =>
      _$RelaisInterestsDataFromJson(json);
}

@freezed
class RelaisInterestModel with _$RelaisInterestModel {
  const RelaisInterestModel._();

  const factory RelaisInterestModel({
    required String id,
    String? clientName,
    /// Dernière alerte ACTIVE du client — pas forcément l'alerte à
    /// l'origine du match avec ce relais (note explicite du backend).
    String? demandId,
    String? message,
    required String status,
    DateTime? meetingDate,
  }) = _RelaisInterestModel;

  factory RelaisInterestModel.fromJson(Map<String, dynamic> json) =>
      _$RelaisInterestModelFromJson(json);

  RelaisInterestStatus get statusEnum => RelaisInterestStatus.fromString(status);
}
