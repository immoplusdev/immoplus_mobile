// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator_provider_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OperatorProviderModelImpl _$$OperatorProviderModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OperatorProviderModelImpl(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      country: json['country'] as String? ?? '',
      method: json['method'] as String? ?? '',
      currency: json['currency'] as String? ?? '',
    );

Map<String, dynamic> _$$OperatorProviderModelImplToJson(
        _$OperatorProviderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'country': instance.country,
      'method': instance.method,
      'currency': instance.currency,
    };
