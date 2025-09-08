import 'package:json_annotation/json_annotation.dart';

part 'reset_password_body.g.dart';

@JsonSerializable()
class ResetPasswordBody {
  final String username;
  final String otp;
  final String newPassword;

  ResetPasswordBody({
    required this.username,
    required this.otp,
    required this.newPassword,
  });

  factory ResetPasswordBody.fromJson(Map<String, Object?> json) =>
      _$ResetPasswordBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordBodyToJson(this);
}
