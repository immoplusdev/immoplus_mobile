import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_otp_body.freezed.dart';
part 'login_otp_body.g.dart';

@freezed
class LoginOtpBody with _$LoginOtpBody {
  const factory LoginOtpBody({
    required String phoneNumber,
    required String otp,
  }) = _LoginOtpBody;

  factory LoginOtpBody.fromJson(Map<String, dynamic> json) =>
      _$LoginOtpBodyFromJson(json);
}
