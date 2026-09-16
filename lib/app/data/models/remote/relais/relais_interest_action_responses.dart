import 'package:freezed_annotation/freezed_annotation.dart';

part 'relais_interest_action_responses.freezed.dart';
part 'relais_interest_action_responses.g.dart';

/// Réponse de `PATCH /relais/:id/interests/:interestId`
/// (`respond-to-immo-relais-interest-command.handler.ts`). `relaisStatus`
/// reflète l'effet de bord : si `status: "in_progress"`, le relais entier
/// bascule aussi en `in_progress`.
@freezed
class RelaisRespondInterestResponse with _$RelaisRespondInterestResponse {
  const factory RelaisRespondInterestResponse({
    required RelaisRespondInterestData data,
  }) = _RelaisRespondInterestResponse;

  factory RelaisRespondInterestResponse.fromJson(Map<String, dynamic> json) =>
      _$RelaisRespondInterestResponseFromJson(json);
}

@freezed
class RelaisRespondInterestData with _$RelaisRespondInterestData {
  const factory RelaisRespondInterestData({
    required String relaisId,
    required String interestId,
    required String status,
    String? relaisStatus,
    DateTime? meetingDate,
  }) = _RelaisRespondInterestData;

  factory RelaisRespondInterestData.fromJson(Map<String, dynamic> json) =>
      _$RelaisRespondInterestDataFromJson(json);
}

/// Réponse de `POST /relais/:id/interests`
/// (`express-immo-relais-interest-command.handler.ts`).
@freezed
class RelaisExpressInterestResponse with _$RelaisExpressInterestResponse {
  const factory RelaisExpressInterestResponse({
    required RelaisExpressInterestData data,
  }) = _RelaisExpressInterestResponse;

  factory RelaisExpressInterestResponse.fromJson(Map<String, dynamic> json) =>
      _$RelaisExpressInterestResponseFromJson(json);
}

@freezed
class RelaisExpressInterestData with _$RelaisExpressInterestData {
  const factory RelaisExpressInterestData({
    required String id,
    required String relaisId,
    String? clientId,
    required String status,
    DateTime? createdAt,
  }) = _RelaisExpressInterestData;

  factory RelaisExpressInterestData.fromJson(Map<String, dynamic> json) =>
      _$RelaisExpressInterestDataFromJson(json);
}
