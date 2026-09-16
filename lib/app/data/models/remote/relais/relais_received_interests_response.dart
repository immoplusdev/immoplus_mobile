import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/enums/relais_interest_status.dart';
import 'relais_list_response.dart';
import 'relais_model.dart';

part 'relais_received_interests_response.freezed.dart';
part 'relais_received_interests_response.g.dart';

/// Réponse de `GET /relais/interests/received` — intérêts reçus, agrégés
/// sur TOUS mes relais (équivalent transversal de `GET /relais/:id/interests`).
@freezed
class ReceivedRelaisInterestsResponse with _$ReceivedRelaisInterestsResponse {
  const factory ReceivedRelaisInterestsResponse({
    @Default([]) List<ReceivedRelaisInterestModel> data,
    RelaisPagination? pagination,
  }) = _ReceivedRelaisInterestsResponse;

  factory ReceivedRelaisInterestsResponse.fromJson(Map<String, dynamic> json) =>
      _$ReceivedRelaisInterestsResponseFromJson(json);
}

@freezed
class ReceivedRelaisInterestModel with _$ReceivedRelaisInterestModel {
  const ReceivedRelaisInterestModel._();

  const factory ReceivedRelaisInterestModel({
    required String id,
    required String relaisId,
    String? clientName,
    String? message,
    required String status,
    DateTime? meetingDate,
    DateTime? createdAt,
    RelaisModel? relais,
  }) = _ReceivedRelaisInterestModel;

  factory ReceivedRelaisInterestModel.fromJson(Map<String, dynamic> json) =>
      _$ReceivedRelaisInterestModelFromJson(json);

  RelaisInterestStatus get statusEnum => RelaisInterestStatus.fromString(status);
}
