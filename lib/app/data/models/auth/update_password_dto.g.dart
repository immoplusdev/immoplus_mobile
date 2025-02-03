// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_password_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdatePasswordDtoImpl _$$UpdatePasswordDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdatePasswordDtoImpl(
      oldPassword: json['oldPassword'] as String,
      newPassword: json['newPassword'] as String,
    );

Map<String, dynamic> _$$UpdatePasswordDtoImplToJson(
        _$UpdatePasswordDtoImpl instance) =>
    <String, dynamic>{
      'oldPassword': instance.oldPassword,
      'newPassword': instance.newPassword,
    };
