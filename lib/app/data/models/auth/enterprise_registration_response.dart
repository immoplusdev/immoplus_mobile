import 'package:freezed_annotation/freezed_annotation.dart';

part 'enterprise_registration_response.freezed.dart';
part 'enterprise_registration_response.g.dart';

@freezed
class EnterpriseRegistrationResponse with _$EnterpriseRegistrationResponse {
  factory EnterpriseRegistrationResponse() = _EnterpriseRegistrationResponse;

  factory EnterpriseRegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$EnterpriseRegistrationResponseFromJson(json);
}
