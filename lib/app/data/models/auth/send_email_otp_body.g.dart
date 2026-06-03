// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_email_otp_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendEmailOtpBody _$SendEmailOtpBodyFromJson(Map<String, dynamic> json) =>
    SendEmailOtpBody(
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      is_whatssap: json['is_whatssap'] as bool?,
    );

Map<String, dynamic> _$SendEmailOtpBodyToJson(SendEmailOtpBody instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'is_whatssap': instance.is_whatssap,
    };
