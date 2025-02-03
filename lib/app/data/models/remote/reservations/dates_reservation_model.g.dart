// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dates_reservation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DatesReservationModelImpl _$$DatesReservationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DatesReservationModelImpl(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$DatesReservationModelImplToJson(
        _$DatesReservationModelImpl instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
    };
