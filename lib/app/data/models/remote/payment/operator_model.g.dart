// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OperatorModelImpl _$$OperatorModelImplFromJson(Map<String, dynamic> json) =>
    _$OperatorModelImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      value: json['value'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
      prefix: json['prefix'] as String? ?? '',
      fee: (json['fee'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$OperatorModelImplToJson(_$OperatorModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'value': instance.value,
      'logo': instance.logo,
      'prefix': instance.prefix,
      'fee': instance.fee,
    };
