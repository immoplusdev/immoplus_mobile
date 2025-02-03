// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demande_visit_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DemandeVisitRequestBodyImpl _$$DemandeVisitRequestBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$DemandeVisitRequestBodyImpl(
      bienImmobilier: json['bienImmobilier'] as String,
      typeDemandeVisite: json['typeDemandeVisite'] as String,
      clientPhoneNumber: json['clientPhoneNumber'] as String,
    );

Map<String, dynamic> _$$DemandeVisitRequestBodyImplToJson(
        _$DemandeVisitRequestBodyImpl instance) =>
    <String, dynamic>{
      'bienImmobilier': instance.bienImmobilier,
      'typeDemandeVisite': instance.typeDemandeVisite,
      'clientPhoneNumber': instance.clientPhoneNumber,
    };
