// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proprietaire_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProprietaireModelImpl _$$ProprietaireModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProprietaireModelImpl(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
    );

Map<String, dynamic> _$$ProprietaireModelImplToJson(
        _$ProprietaireModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
    };
