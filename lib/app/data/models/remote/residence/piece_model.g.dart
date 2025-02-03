// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piece_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PieceModelImpl _$$PieceModelImplFromJson(Map<String, dynamic> json) =>
    _$PieceModelImpl(
      nom: json['nom'] as String? ?? '',
      nombre: (json['nombre'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PieceModelImplToJson(_$PieceModelImpl instance) =>
    <String, dynamic>{
      'nom': instance.nom,
      'nombre': instance.nombre,
    };
