// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_body_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginBodyModelImpl _$$LoginBodyModelImplFromJson(Map<String, dynamic> json) =>
    _$LoginBodyModelImpl(
      username: json['username'] as String?,
      password: json['password'] as String?,
      source: json['source'] as String,
    );

Map<String, dynamic> _$$LoginBodyModelImplToJson(
        _$LoginBodyModelImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'source': instance.source,
    };
