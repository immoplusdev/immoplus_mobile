// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demande_visite_body_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DemandeVisiteBodyModelImpl _$$DemandeVisiteBodyModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DemandeVisiteBodyModelImpl(
      bienImmobilier: json['bienImmobilier'] as String? ?? '',
      typeDemandeVisite: json['typeDemandeVisite'] as String? ?? '',
      datesDemandeVisite: (json['datesDemandeVisite'] as List<dynamic>?)
              ?.map(
                  (e) => DateDemandeVisite.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      clientPhoneNumber: json['clientPhoneNumber'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
    );

Map<String, dynamic> _$$DemandeVisiteBodyModelImplToJson(
        _$DemandeVisiteBodyModelImpl instance) =>
    <String, dynamic>{
      'bienImmobilier': instance.bienImmobilier,
      'typeDemandeVisite': instance.typeDemandeVisite,
      'datesDemandeVisite': instance.datesDemandeVisite,
      'clientPhoneNumber': instance.clientPhoneNumber,
      'notes': instance.notes,
    };
