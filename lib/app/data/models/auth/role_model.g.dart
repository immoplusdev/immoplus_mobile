// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoleModelImpl _$$RoleModelImplFromJson(Map<String, dynamic> json) =>
    _$RoleModelImpl(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      enforceTfa: json['enforceTfa'] as bool?,
      appAccess: json['appAccess'] as bool?,
      adminAccess: json['adminAccess'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$RoleModelImplToJson(_$RoleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'enforceTfa': instance.enforceTfa,
      'appAccess': instance.appAccess,
      'adminAccess': instance.adminAccess,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
