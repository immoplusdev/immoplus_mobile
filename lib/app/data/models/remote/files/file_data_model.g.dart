// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FileDataModelImpl _$$FileDataModelImplFromJson(Map<String, dynamic> json) =>
    _$FileDataModelImpl(
      data: json['data'] == null
          ? null
          : InnerFileDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FileDataModelImplToJson(_$FileDataModelImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
