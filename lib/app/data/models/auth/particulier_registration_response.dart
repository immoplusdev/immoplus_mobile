import 'package:freezed_annotation/freezed_annotation.dart';

part 'particulier_registration_response.freezed.dart';
part 'particulier_registration_response.g.dart';

@freezed
class ParticulierRegistrationResponse with _$ParticulierRegistrationResponse {
  factory ParticulierRegistrationResponse({
    @JsonKey(name: 'name') String? name,
  }) = _ParticulierRegistrationResponse;

  factory ParticulierRegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$ParticulierRegistrationResponseFromJson(json);
}
