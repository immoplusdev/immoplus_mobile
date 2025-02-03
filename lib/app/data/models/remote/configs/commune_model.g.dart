// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commune_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommuneModelImpl _$$CommuneModelImplFromJson(Map<String, dynamic> json) =>
    _$CommuneModelImpl(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      createdBy: json['createdBy'] as String? ?? null,
      villeId: json['villeId'] as String? ?? '',
    );

Map<String, dynamic> _$$CommuneModelImplToJson(_$CommuneModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'villeId': instance.villeId,
    };
