import 'package:freezed_annotation/freezed_annotation.dart';

part 'enterprise_registration_body.freezed.dart';
part 'enterprise_registration_body.g.dart';

@freezed
class EnterpriseRegistrationBody with _$EnterpriseRegistrationBody {
  factory EnterpriseRegistrationBody({
    String? email,
    String? phoneNumber,
    String? password,
    String? nomEntreprise,
    String? emailEntreprise,
    String? registreCommerceId,
    String? numeroContribuable,
    String? typeEntreprise,
  }) = _EnterpriseRegistrationBody;

  factory EnterpriseRegistrationBody.fromJson(Map<String, dynamic> json) =>
      _$EnterpriseRegistrationBodyFromJson(json);
}
