// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      language: json['language'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      otp: json['otp'] as String?,
      otpExpiration: json['otpExpiration'] as String?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      commune: json['commune'] as String?,
      address: json['address'] as String?,
      address2: json['address2'] as String?,
      currency: json['currency'] as String?,
      identityVerified: json['identityVerified'] as bool?,
      emailVerified: json['emailVerified'] as bool?,
      phoneNumberVerified: json['phoneNumberVerified'] as bool?,
      authLoginAttempts: (json['authLoginAttempts'] as num?)?.toInt(),
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      avatar: json['avatar'] as String?,
      role: RoleModel.fromJson(json['role'] as Map<String, dynamic>),
      additionalData: AdditionalDataModel.fromJson(
          json['additionalData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'password': instance.password,
      'language': instance.language,
      'phoneNumber': instance.phoneNumber,
      'otp': instance.otp,
      'otpExpiration': instance.otpExpiration,
      'country': instance.country,
      'state': instance.state,
      'city': instance.city,
      'commune': instance.commune,
      'address': instance.address,
      'address2': instance.address2,
      'currency': instance.currency,
      'identityVerified': instance.identityVerified,
      'emailVerified': instance.emailVerified,
      'phoneNumberVerified': instance.phoneNumberVerified,
      'authLoginAttempts': instance.authLoginAttempts,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'avatar': instance.avatar,
      'role': instance.role,
      'additionalData': instance.additionalData,
    };
