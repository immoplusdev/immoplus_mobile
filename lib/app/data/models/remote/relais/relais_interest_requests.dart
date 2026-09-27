import 'package:freezed_annotation/freezed_annotation.dart';

part 'relais_interest_requests.freezed.dart';
part 'relais_interest_requests.g.dart';

/// Body de `PATCH /relais/:id/interests/:interestId` — `status` accepte
/// uniquement `"in_progress"` ou `"declined"` côté serveur (400 sinon).
@freezed
class RelaisInterestResponseRequest with _$RelaisInterestResponseRequest {
  const factory RelaisInterestResponseRequest({
    required String status,
    String? meetingDate,
  }) = _RelaisInterestResponseRequest;

  factory RelaisInterestResponseRequest.fromJson(Map<String, dynamic> json) =>
      _$RelaisInterestResponseRequestFromJson(json);
}

/// Body de `POST /relais/:id/interests` — `message` optionnel, max 2000
/// caractères (validé côté serveur).
@freezed
class RelaisExpressInterestRequest with _$RelaisExpressInterestRequest {
  const factory RelaisExpressInterestRequest({
    String? message,
  }) = _RelaisExpressInterestRequest;

  factory RelaisExpressInterestRequest.fromJson(Map<String, dynamic> json) =>
      _$RelaisExpressInterestRequestFromJson(json);
}
