// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bien_immobilier_creation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BienImmobilierCreationModelImpl _$$BienImmobilierCreationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BienImmobilierCreationModelImpl(
      miniature: json['miniature'] as String? ?? '',
      typeLocation: json['typeLocation'] as String? ?? '',
      nom: json['nom'] as String? ?? '',
      typeBienImmobilier:
          json['typeBienImmobilier'] as String? ?? 'Unknown Type',
      description: json['description'] as String? ?? 'No Description',
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
      video: json['video'] as String? ?? '',
      ville: json['ville'] as String? ?? '',
      commune: json['commune'] as String? ?? '',
      adresse: json['adresse'] as String? ?? '',
      position: json['position'] == null
          ? const PositionModel()
          : PositionModel.fromJson(json['position'] as Map<String, dynamic>),
      prix: (json['prix'] as num?)?.toInt() ?? 0,
      bienImmobilierDisponible:
          json['bienImmobilierDisponible'] as bool? ?? true,
      pieces: (json['pieces'] as List<dynamic>?)
              ?.map((e) => PieceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$BienImmobilierCreationModelImplToJson(
        _$BienImmobilierCreationModelImpl instance) =>
    <String, dynamic>{
      'miniature': instance.miniature,
      'typeLocation': instance.typeLocation,
      'nom': instance.nom,
      'typeBienImmobilier': instance.typeBienImmobilier,
      'description': instance.description,
      'amentities': instance.amentities,
      'tags': instance.tags,
      'images': instance.images,
      'video': instance.video,
      'ville': instance.ville,
      'commune': instance.commune,
      'adresse': instance.adresse,
      'position': instance.position,
      'prix': instance.prix,
      'bienImmobilierDisponible': instance.bienImmobilierDisponible,
      'pieces': instance.pieces,
    };
