// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ville_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VilleModelImpl _$$VilleModelImplFromJson(Map<String, dynamic> json) =>
    _$VilleModelImpl(
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
    );

Map<String, dynamic> _$$VilleModelImplToJson(_$VilleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
