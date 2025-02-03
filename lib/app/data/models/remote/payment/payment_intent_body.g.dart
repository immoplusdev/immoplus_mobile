// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_intent_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentIntentBodyImpl _$$PaymentIntentBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentIntentBodyImpl(
      collection: json['collection'] as String? ?? '',
      itemId: json['itemId'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? '',
      paymentCredentials: json['paymentCredentials'] as String? ?? '',
    );

Map<String, dynamic> _$$PaymentIntentBodyImplToJson(
        _$PaymentIntentBodyImpl instance) =>
    <String, dynamic>{
      'collection': instance.collection,
      'itemId': instance.itemId,
      'paymentMethod': instance.paymentMethod,
      'paymentCredentials': instance.paymentCredentials,
    };
