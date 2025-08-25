// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'estimate_price_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EstimatePriceModelImpl _$$EstimatePriceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EstimatePriceModelImpl(
      data: json['data'] == null
          ? null
          : EstimatePriceData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$EstimatePriceModelImplToJson(
        _$EstimatePriceModelImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$EstimatePriceDataImpl _$$EstimatePriceDataImplFromJson(
        Map<String, dynamic> json) =>
    _$EstimatePriceDataImpl(
      residence: json['residence'] as String? ?? '',
      datesReservation: (json['datesReservation'] as List<dynamic>?)
              ?.map((e) => ReservationDate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      montantTotalReservation:
          (json['montantTotalReservation'] as num?)?.toDouble() ?? 0,
      montantReservationSansCommission:
          (json['montantReservationSansCommission'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$EstimatePriceDataImplToJson(
        _$EstimatePriceDataImpl instance) =>
    <String, dynamic>{
      'residence': instance.residence,
      'datesReservation': instance.datesReservation,
      'montantTotalReservation': instance.montantTotalReservation,
      'montantReservationSansCommission':
          instance.montantReservationSansCommission,
    };

_$ReservationDateImpl _$$ReservationDateImplFromJson(
        Map<String, dynamic> json) =>
    _$ReservationDateImpl(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$ReservationDateImplToJson(
        _$ReservationDateImpl instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
    };
