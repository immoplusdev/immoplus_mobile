// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_itent_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentItentDataImpl _$$PaymentItentDataImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentItentDataImpl(
      id: json['id'] as String? ?? '',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      amountNoFees: (json['amountNoFees'] as num?)?.toInt() ?? 0,
      paymentType: json['paymentType'] as String? ?? '',
      collection: json['collection'] as String? ?? '',
      paymentStatus: json['paymentStatus'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? '',
      itemId: json['itemId'] as String? ?? '',
      hub2PaymentId: json['hub2PaymentId'] as String? ?? '',
      hub2Exception: json['hub2Exception'] as String?,
      hub2NextAction: json['hub2NextAction'] == null
          ? null
          : Hub2NextAction.fromJson(
              json['hub2NextAction'] as Map<String, dynamic>),
      hub2Token: json['hub2Token'] as String? ?? '',
      stripePaymentIntentId: json['stripePaymentIntentId'] as String?,
      stripeClientSecret: json['stripeClientSecret'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$$PaymentItentDataImplToJson(
        _$PaymentItentDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'amountNoFees': instance.amountNoFees,
      'paymentType': instance.paymentType,
      'collection': instance.collection,
      'paymentStatus': instance.paymentStatus,
      'paymentMethod': instance.paymentMethod,
      'itemId': instance.itemId,
      'hub2PaymentId': instance.hub2PaymentId,
      'hub2Exception': instance.hub2Exception,
      'hub2NextAction': instance.hub2NextAction,
      'hub2Token': instance.hub2Token,
      'stripePaymentIntentId': instance.stripePaymentIntentId,
      'stripeClientSecret': instance.stripeClientSecret,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
