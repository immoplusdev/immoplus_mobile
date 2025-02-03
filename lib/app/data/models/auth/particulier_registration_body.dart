import 'package:freezed_annotation/freezed_annotation.dart';

part 'particulier_registration_body.freezed.dart';
part 'particulier_registration_body.g.dart';

@freezed
class ParticulierRegistrationBody with _$ParticulierRegistrationBody {
  factory ParticulierRegistrationBody({
    String? firstName,
    String? lastName,
    //@JsonKey(name: 'city') String? city,
    String? email,
    String? phoneNumber,
    String? password,
    String? activite,
    String? photoIdentiteId,
    String? pieceIdentiteId,
  }) = _ParticulierRegistrationBody;

  factory ParticulierRegistrationBody.fromJson(Map<String, dynamic> json) =>
      _$ParticulierRegistrationBodyFromJson(json);
}
