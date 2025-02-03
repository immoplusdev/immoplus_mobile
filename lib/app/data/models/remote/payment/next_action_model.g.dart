// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'next_action_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NextActionDataImpl _$$NextActionDataImplFromJson(Map<String, dynamic> json) =>
    _$NextActionDataImpl(
      url: json['url'] as String? ?? '',
      method: json['method'] as String? ?? '',
    );

Map<String, dynamic> _$$NextActionDataImplToJson(
        _$NextActionDataImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'method': instance.method,
    };

_$Hub2NextActionImpl _$$Hub2NextActionImplFromJson(Map<String, dynamic> json) =>
    _$Hub2NextActionImpl(
      type: json['type'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] == null
          ? const NextActionData()
          : NextActionData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$Hub2NextActionImplToJson(
        _$Hub2NextActionImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'message': instance.message,
      'data': instance.data,
    };
