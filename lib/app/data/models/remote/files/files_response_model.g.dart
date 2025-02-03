// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FileResponseModelImpl _$$FileResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FileResponseModelImpl(
      data: json['data'] == null
          ? null
          : FileDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FileResponseModelImplToJson(
        _$FileResponseModelImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
