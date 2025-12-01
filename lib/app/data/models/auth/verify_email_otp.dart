import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_email_otp.freezed.dart';
part 'verify_email_otp.g.dart';

@freezed
class VerifyEmailOtp with _$VerifyEmailOtp {
  factory VerifyEmailOtp({
    required String email,
    required String otp,
  }) = _VerifyEmailOtp;

  factory VerifyEmailOtp.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailOtpFromJson(json);
}
