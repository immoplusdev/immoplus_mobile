// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReservationRequestBodyImpl _$$ReservationRequestBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$ReservationRequestBodyImpl(
      residence: json['residence'] as String,
      datesReservation: (json['datesReservation'] as List<dynamic>)
          .map((e) => DatesReservationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      clientPhoneNumber: json['clientPhoneNumber'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$ReservationRequestBodyImplToJson(
        _$ReservationRequestBodyImpl instance) =>
    <String, dynamic>{
      'residence': instance.residence,
      'datesReservation': instance.datesReservation,
      'clientPhoneNumber': instance.clientPhoneNumber,
      'notes': instance.notes,
    };
