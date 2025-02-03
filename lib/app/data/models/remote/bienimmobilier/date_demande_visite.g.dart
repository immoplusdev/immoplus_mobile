// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_demande_visite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DateDemandeVisiteImpl _$$DateDemandeVisiteImplFromJson(
        Map<String, dynamic> json) =>
    _$DateDemandeVisiteImpl(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$DateDemandeVisiteImplToJson(
        _$DateDemandeVisiteImpl instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
    };
