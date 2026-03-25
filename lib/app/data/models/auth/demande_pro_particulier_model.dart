import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/enums/demande_pro_particulier_status.dart';

part 'demande_pro_particulier_model.freezed.dart';
part 'demande_pro_particulier_model.g.dart';

@freezed
class DemandeProParticulierModel with _$DemandeProParticulierModel {
  const factory DemandeProParticulierModel({
    required String id,
    required String status,
    required String activite,
    String? rejectionReason,
    required String createdAt,
    required String updatedAt,
    String? deletedAt,
    required String userId,
    required String photoIdentiteId,
    required String pieceIdentiteId,
  }) = _DemandeProParticulierModel;

  factory DemandeProParticulierModel.fromJson(Map<String, dynamic> json) =>
      _$DemandeProParticulierModelFromJson(json);
}

extension DemandeProParticulierModelX on DemandeProParticulierModel {
  DemandeProParticulierStatus get statusEnum =>
      DemandeProParticulierStatus.fromString(status);
}
