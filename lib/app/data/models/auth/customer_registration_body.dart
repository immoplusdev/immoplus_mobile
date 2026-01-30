import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_registration_body.freezed.dart';
part 'customer_registration_body.g.dart';

@freezed
class CustomerRegistrationBody with _$CustomerRegistrationBody {
  factory CustomerRegistrationBody({
    String? avatar,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? password,
    String? token,
    String? provider,
  }) = _CustomerRegistrationBody;

  factory CustomerRegistrationBody.fromJson(Map<String, dynamic> json) =>
      _$CustomerRegistrationBodyFromJson(json);
}
