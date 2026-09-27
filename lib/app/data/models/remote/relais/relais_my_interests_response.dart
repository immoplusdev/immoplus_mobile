import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/enums/relais_interest_status.dart';
import 'relais_list_response.dart';
import 'relais_model.dart';

part 'relais_my_interests_response.freezed.dart';
part 'relais_my_interests_response.g.dart';

/// Réponse de `GET /relais/interests/mine` — les relais sur lesquels j'ai
/// exprimé un intérêt (côté demandeur), avec le résumé du relais imbriqué.
@freezed
class MyRelaisInterestsResponse with _$MyRelaisInterestsResponse {
  const factory MyRelaisInterestsResponse({
    @Default([]) List<MyRelaisInterestModel> data,
    RelaisPagination? pagination,
  }) = _MyRelaisInterestsResponse;

  factory MyRelaisInterestsResponse.fromJson(Map<String, dynamic> json) =>
      _$MyRelaisInterestsResponseFromJson(json);
}

@freezed
class MyRelaisInterestModel with _$MyRelaisInterestModel {
  const MyRelaisInterestModel._();

  const factory MyRelaisInterestModel({
    required String id,
    required String relaisId,
    required String status,
    String? message,
    DateTime? meetingDate,
    DateTime? createdAt,
    RelaisModel? relais,
  }) = _MyRelaisInterestModel;

  factory MyRelaisInterestModel.fromJson(Map<String, dynamic> json) =>
      _$MyRelaisInterestModelFromJson(json);

  RelaisInterestStatus get statusEnum => RelaisInterestStatus.fromString(status);
}
