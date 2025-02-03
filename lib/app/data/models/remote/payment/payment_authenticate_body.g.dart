// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_authenticate_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentAuthenticateBodyImpl _$$PaymentAuthenticateBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentAuthenticateBodyImpl(
      otp: json['otp'] as String? ?? '',
      itemId: json['itemId'] as String? ?? '',
      collection: json['collection'] as String? ?? '',
    );

Map<String, dynamic> _$$PaymentAuthenticateBodyImplToJson(
        _$PaymentAuthenticateBodyImpl instance) =>
    <String, dynamic>{
      'otp': instance.otp,
      'itemId': instance.itemId,
      'collection': instance.collection,
    };
