// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enterprise_registration_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EnterpriseRegistrationBodyImpl _$$EnterpriseRegistrationBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$EnterpriseRegistrationBodyImpl(
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      password: json['password'] as String?,
      nomEntreprise: json['nomEntreprise'] as String?,
      emailEntreprise: json['emailEntreprise'] as String?,
      registreCommerceId: json['registreCommerceId'] as String?,
      numeroContribuable: json['numeroContribuable'] as String?,
      typeEntreprise: json['typeEntreprise'] as String?,
    );

Map<String, dynamic> _$$EnterpriseRegistrationBodyImplToJson(
        _$EnterpriseRegistrationBodyImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'password': instance.password,
      'nomEntreprise': instance.nomEntreprise,
      'emailEntreprise': instance.emailEntreprise,
      'registreCommerceId': instance.registreCommerceId,
      'numeroContribuable': instance.numeroContribuable,
      'typeEntreprise': instance.typeEntreprise,
    };
