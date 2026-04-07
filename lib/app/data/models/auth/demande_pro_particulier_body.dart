import 'package:json_annotation/json_annotation.dart';

part 'demande_pro_particulier_body.g.dart';

@JsonSerializable()
class DemandeProParticulierBody {
  final String activite;
  final String photoIdentiteId;
  final String pieceIdentiteId;

  DemandeProParticulierBody({
    required this.activite,
    required this.photoIdentiteId,
    required this.pieceIdentiteId,
  });

  factory DemandeProParticulierBody.fromJson(Map<String, dynamic> json) =>
      _$DemandeProParticulierBodyFromJson(json);

  Map<String, dynamic> toJson() => _$DemandeProParticulierBodyToJson(this);
}
