import 'package:freezed_annotation/freezed_annotation.dart';
import 'demande_pro_particulier_model.dart';

part 'demande_pro_particulier_me_response.freezed.dart';
part 'demande_pro_particulier_me_response.g.dart';

@freezed
class DemandeProParticulierMeResponse with _$DemandeProParticulierMeResponse {
  const factory DemandeProParticulierMeResponse({
    required List<DemandeProParticulierModel> data,
    required int currentPage,
    required int totalPages,
    required int pageSize,
    required int totalCount,
    required bool hasNext,
    required bool hasPrevious,
  }) = _DemandeProParticulierMeResponse;

  factory DemandeProParticulierMeResponse.fromJson(
          Map<String, dynamic> json) =>
      _$DemandeProParticulierMeResponseFromJson(json);
}
