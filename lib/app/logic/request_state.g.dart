// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestStateImpl _$$RequestStateImplFromJson(Map<String, dynamic> json) =>
    _$RequestStateImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$RequestStateImplToJson(_$RequestStateImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$REQUEST_INITIALImpl _$$REQUEST_INITIALImplFromJson(
        Map<String, dynamic> json) =>
    _$REQUEST_INITIALImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$REQUEST_INITIALImplToJson(
        _$REQUEST_INITIALImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$REQUEST_LOADINGImpl _$$REQUEST_LOADINGImplFromJson(
        Map<String, dynamic> json) =>
    _$REQUEST_LOADINGImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$REQUEST_LOADINGImplToJson(
        _$REQUEST_LOADINGImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$REQUEST_SUCCESSImpl _$$REQUEST_SUCCESSImplFromJson(
        Map<String, dynamic> json) =>
    _$REQUEST_SUCCESSImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$REQUEST_SUCCESSImplToJson(
        _$REQUEST_SUCCESSImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$REQUEST_ERRORImpl _$$REQUEST_ERRORImplFromJson(Map<String, dynamic> json) =>
    _$REQUEST_ERRORImpl(
      error: json['error'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$REQUEST_ERRORImplToJson(_$REQUEST_ERRORImpl instance) =>
    <String, dynamic>{
      'error': instance.error,
      'runtimeType': instance.$type,
    };

_$REQUEST_RESIDENCE_DATAImpl _$$REQUEST_RESIDENCE_DATAImplFromJson(
        Map<String, dynamic> json) =>
    _$REQUEST_RESIDENCE_DATAImpl(
      data: ResidenceModel.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$REQUEST_RESIDENCE_DATAImplToJson(
        _$REQUEST_RESIDENCE_DATAImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'runtimeType': instance.$type,
    };

_$REQUEST_BIEN_IMMOBILIER_DATAImpl _$$REQUEST_BIEN_IMMOBILIER_DATAImplFromJson(
        Map<String, dynamic> json) =>
    _$REQUEST_BIEN_IMMOBILIER_DATAImpl(
      data: BienImmobilierModel.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$REQUEST_BIEN_IMMOBILIER_DATAImplToJson(
        _$REQUEST_BIEN_IMMOBILIER_DATAImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'runtimeType': instance.$type,
    };

_$REQUEST_RESIDENCES_DATAImpl _$$REQUEST_RESIDENCES_DATAImplFromJson(
        Map<String, dynamic> json) =>
    _$REQUEST_RESIDENCES_DATAImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => ResidenceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$REQUEST_RESIDENCES_DATAImplToJson(
        _$REQUEST_RESIDENCES_DATAImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'runtimeType': instance.$type,
    };

_$REQUEST_VILLES_DATAImpl _$$REQUEST_VILLES_DATAImplFromJson(
        Map<String, dynamic> json) =>
    _$REQUEST_VILLES_DATAImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => VilleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$REQUEST_VILLES_DATAImplToJson(
        _$REQUEST_VILLES_DATAImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'runtimeType': instance.$type,
    };

_$REQUEST_COMMUNES_DATAImpl _$$REQUEST_COMMUNES_DATAImplFromJson(
        Map<String, dynamic> json) =>
    _$REQUEST_COMMUNES_DATAImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => CommuneModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$REQUEST_COMMUNES_DATAImplToJson(
        _$REQUEST_COMMUNES_DATAImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'runtimeType': instance.$type,
    };
