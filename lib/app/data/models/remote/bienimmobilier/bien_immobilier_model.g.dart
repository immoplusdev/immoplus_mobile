// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bien_immobilier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BienImmobilierModelImpl _$$BienImmobilierModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BienImmobilierModelImpl(
      id: json['id'] as String? ?? '',
      nom: json['nom'] as String? ?? '',
      typeBienImmobilier: json['typeBienImmobilier'] as String? ?? '',
      typeLocation: json['typeLocation'] as String? ?? '',
      description: json['description'] as String? ?? '',
      amentities: (json['amentities'] as List<dynamic>?)
              ?.map((e) => CommoditeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      adresse: json['adresse'] as String? ?? '',
      position: json['position'] == null
          ? const PositionModel()
          : PositionModel.fromJson(json['position'] as Map<String, dynamic>),
      statusValidation: json['statusValidation'] as String? ?? '',
      prix: (json['prix'] as num?)?.toInt() ?? 0,
      featured: json['featured'] as bool? ?? false,
      bienImmobilierDisponible:
          json['bienImmobilierDisponible'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      miniatureId: json['miniatureId'] as String? ?? '',
      pieces: (json['pieces'] as List<dynamic>?)
              ?.map((e) => PieceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      ville: json['ville'] as String? ?? '',
      commune: json['commune'] as String? ?? '',
      villeModel: json['ville_model'] == null
          ? null
          : VilleModel.fromJson(json['ville_model'] as Map<String, dynamic>),
      communeModel: json['commune_model'] == null
          ? null
          : CommuneModel.fromJson(
              json['commune_model'] as Map<String, dynamic>),
      video: json['video'] as String? ?? '',
      aLouer: json['aLouer'] as bool? ?? false,
      latitude: toDouble(json['latitude']),
      longitude: toDouble(json['longitude']),
      nombreMaxOccupants: toInt(json['nombreMaxOccupants']),
      fetesAutorises: json['fetesAutorises'] as bool? ?? false,
      score: json['score'] as num?,
    );

Map<String, dynamic> _$$BienImmobilierModelImplToJson(
        _$BienImmobilierModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'typeBienImmobilier': instance.typeBienImmobilier,
      'typeLocation': instance.typeLocation,
      'description': instance.description,
      'amentities': instance.amentities,
      'tags': instance.tags,
      'images': instance.images,
      'adresse': instance.adresse,
      'position': instance.position,
      'statusValidation': instance.statusValidation,
      'prix': instance.prix,
      'featured': instance.featured,
      'bienImmobilierDisponible': instance.bienImmobilierDisponible,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'miniatureId': instance.miniatureId,
      'pieces': instance.pieces,
      'ville': instance.ville,
      'commune': instance.commune,
      'ville_model': instance.villeModel,
      'commune_model': instance.communeModel,
      'video': instance.video,
      'aLouer': instance.aLouer,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'nombreMaxOccupants': instance.nombreMaxOccupants,
      'fetesAutorises': instance.fetesAutorises,
      'score': instance.score,
    };
