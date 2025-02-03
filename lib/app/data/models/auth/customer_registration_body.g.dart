// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_registration_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerRegistrationBodyImpl _$$CustomerRegistrationBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$CustomerRegistrationBodyImpl(
      avatar: json['avatar'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$$CustomerRegistrationBodyImplToJson(
        _$CustomerRegistrationBodyImpl instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'password': instance.password,
    };
