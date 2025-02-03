// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inner_file_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InnerFileDataModelImpl _$$InnerFileDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$InnerFileDataModelImpl(
      type: json['type'] as String?,
      title: json['title'] as String?,
      folder: json['folder'] as String?,
      storage: json['storage'] as String?,
      description: json['description'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt(),
      fileNameDisk: json['fileNameDisk'] as String?,
      fileNameDownload: json['fileNameDownload'] as String?,
      uploadedBy: json['uploadedBy'] as String?,
      charset: json['charset'] as String?,
      filesize: (json['filesize'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      embed: json['embed'] as String?,
      location: json['location'] as String?,
      tags: json['tags'] as String?,
      metadata: json['metadata'] as String?,
      focalPointX: (json['focalPointX'] as num?)?.toDouble(),
      focalPointY: (json['focalPointY'] as num?)?.toDouble(),
      tusId: json['tusId'] as String?,
      tusData: json['tusData'] as String?,
      id: json['id'] as String?,
      uploadedOn: json['uploadedOn'] == null
          ? null
          : DateTime.parse(json['uploadedOn'] as String),
      modifiedOn: json['modifiedOn'] == null
          ? null
          : DateTime.parse(json['modifiedOn'] as String),
      deletedOn: json['deletedOn'] == null
          ? null
          : DateTime.parse(json['deletedOn'] as String),
    );

Map<String, dynamic> _$$InnerFileDataModelImplToJson(
        _$InnerFileDataModelImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'folder': instance.folder,
      'storage': instance.storage,
      'description': instance.description,
      'fileSize': instance.fileSize,
      'fileNameDisk': instance.fileNameDisk,
      'fileNameDownload': instance.fileNameDownload,
      'uploadedBy': instance.uploadedBy,
      'charset': instance.charset,
      'filesize': instance.filesize,
      'width': instance.width,
      'height': instance.height,
      'duration': instance.duration,
      'embed': instance.embed,
      'location': instance.location,
      'tags': instance.tags,
      'metadata': instance.metadata,
      'focalPointX': instance.focalPointX,
      'focalPointY': instance.focalPointY,
      'tusId': instance.tusId,
      'tusData': instance.tusData,
      'id': instance.id,
      'uploadedOn': instance.uploadedOn?.toIso8601String(),
      'modifiedOn': instance.modifiedOn?.toIso8601String(),
      'deletedOn': instance.deletedOn?.toIso8601String(),
    };
