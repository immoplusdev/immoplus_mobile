// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demande_visite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DemandeVisiteModelImpl _$$DemandeVisiteModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DemandeVisiteModelImpl(
      id: json['id'] as String? ?? '',
      statusDemandeVisite: json['statusDemandeVisite'] as String?,
      typeDemandeVisite: json['typeDemandeVisite'] as String?,
      datesDemandeVisite: (json['datesDemandeVisite'] as List<dynamic>?)
              ?.map(
                  (e) => DateDemandeVisite.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      statusFacture: json['statusFacture'] as String?,
      retraitProEffectue: json['retraitProEffectue'] as bool? ?? false,
      montantTotalDemandeVisite:
          (json['montantTotalDemandeVisite'] as num?)?.toInt() ?? 0,
      montantDemandeVisiteSansCommission:
          (json['montantDemandeVisiteSansCommission'] as num?)?.toInt() ?? 0,
      notes: json['notes'] as String?,
      clientPhoneNumber: json['clientPhoneNumber'] as String?,
      bienImmobilier: json['bienImmobilier'] == null
          ? null
          : BienImmobilierModel.fromJson(
              json['bienImmobilier'] as Map<String, dynamic>),
      bienImmobilierId: json['bienImmobilierId'] as String?,
      client: json['client'] == null
          ? null
          : ClientModel.fromJson(json['client'] as Map<String, dynamic>),
      proprietaire: json['proprietaire'] == null
          ? null
          : ClientModel.fromJson(json['proprietaire'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
    );

Map<String, dynamic> _$$DemandeVisiteModelImplToJson(
        _$DemandeVisiteModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'statusDemandeVisite': instance.statusDemandeVisite,
      'typeDemandeVisite': instance.typeDemandeVisite,
      'datesDemandeVisite': instance.datesDemandeVisite,
      'statusFacture': instance.statusFacture,
      'retraitProEffectue': instance.retraitProEffectue,
      'montantTotalDemandeVisite': instance.montantTotalDemandeVisite,
      'montantDemandeVisiteSansCommission':
          instance.montantDemandeVisiteSansCommission,
      'notes': instance.notes,
      'clientPhoneNumber': instance.clientPhoneNumber,
      'bienImmobilier': instance.bienImmobilier,
      'bienImmobilierId': instance.bienImmobilierId,
      'client': instance.client,
      'proprietaire': instance.proprietaire,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
    };
