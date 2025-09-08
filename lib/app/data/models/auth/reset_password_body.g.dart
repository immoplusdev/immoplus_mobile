// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordBody _$ResetPasswordBodyFromJson(Map<String, dynamic> json) =>
    ResetPasswordBody(
      username: json['username'] as String,
      otp: json['otp'] as String,
      newPassword: json['newPassword'] as String,
    );

Map<String, dynamic> _$ResetPasswordBodyToJson(ResetPasswordBody instance) =>
    <String, dynamic>{
      'username': instance.username,
      'otp': instance.otp,
      'newPassword': instance.newPassword,
    };
