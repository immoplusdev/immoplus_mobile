import 'package:freezed_annotation/freezed_annotation.dart';

part 'relais_cancel_response.freezed.dart';
part 'relais_cancel_response.g.dart';

/// Réponse de `DELETE /relais/:id` (`cancel-immo-relais-command.handler.ts`)
/// — pas le modèle complet, juste `{id, status, message}`.
@freezed
class RelaisCancelResponse with _$RelaisCancelResponse {
  const factory RelaisCancelResponse({
    required RelaisCancelData data,
  }) = _RelaisCancelResponse;

  factory RelaisCancelResponse.fromJson(Map<String, dynamic> json) =>
      _$RelaisCancelResponseFromJson(json);
}

@freezed
class RelaisCancelData with _$RelaisCancelData {
  const factory RelaisCancelData({
    required String id,
    required String status,
    String? message,
  }) = _RelaisCancelData;

  factory RelaisCancelData.fromJson(Map<String, dynamic> json) =>
      _$RelaisCancelDataFromJson(json);
}
