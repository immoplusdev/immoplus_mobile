import 'package:freezed_annotation/freezed_annotation.dart';

part 'relais_matches_response.freezed.dart';
part 'relais_matches_response.g.dart';

/// Réponse de `GET /relais/:id/matches`
/// (`get-immo-relais-matches-query.handler.ts`) — les alertes (demandeurs)
/// qui correspondent à ce relais.
@freezed
class RelaisMatchesResponse with _$RelaisMatchesResponse {
  const factory RelaisMatchesResponse({
    required RelaisMatchesData data,
  }) = _RelaisMatchesResponse;

  factory RelaisMatchesResponse.fromJson(Map<String, dynamic> json) =>
      _$RelaisMatchesResponseFromJson(json);
}

@freezed
class RelaisMatchesData with _$RelaisMatchesData {
  const factory RelaisMatchesData({
    required String relaisId,
    @Default(0) int matchCount,
    @Default([]) List<RelaisMatchModel> matches,
  }) = _RelaisMatchesData;

  factory RelaisMatchesData.fromJson(Map<String, dynamic> json) =>
      _$RelaisMatchesDataFromJson(json);
}

@freezed
class RelaisMatchModel with _$RelaisMatchModel {
  const factory RelaisMatchModel({
    required String id,
    String? userId,
    String? userName,
    String? title,
    RelaisMatchCriteria? criteria,
    num? matchScore,
  }) = _RelaisMatchModel;

  factory RelaisMatchModel.fromJson(Map<String, dynamic> json) =>
      _$RelaisMatchModelFromJson(json);
}

@freezed
class RelaisMatchCriteria with _$RelaisMatchCriteria {
  const factory RelaisMatchCriteria({
    String? location,
    @JsonKey(name: 'price_min') int? priceMin,
    @JsonKey(name: 'price_max') int? priceMax,
  }) = _RelaisMatchCriteria;

  factory RelaisMatchCriteria.fromJson(Map<String, dynamic> json) =>
      _$RelaisMatchCriteriaFromJson(json);
}
