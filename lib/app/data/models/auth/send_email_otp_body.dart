import 'package:json_annotation/json_annotation.dart';

part 'send_email_otp_body.g.dart';

@JsonSerializable()
class SendEmailOtpBody {
  final String? email;
  final String? phoneNumber;
  final bool? is_whatssap;

  SendEmailOtpBody({
    this.email,
    this.phoneNumber,
    this.is_whatssap,
  });

  factory SendEmailOtpBody.fromJson(Map<String, Object?> json) =>
      _$SendEmailOtpBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SendEmailOtpBodyToJson(this);
}
