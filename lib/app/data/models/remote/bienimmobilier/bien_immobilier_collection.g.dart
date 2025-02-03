// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bien_immobilier_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BienImmobilierCollectionImpl _$$BienImmobilierCollectionImplFromJson(
        Map<String, dynamic> json) =>
    _$BienImmobilierCollectionImpl(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) =>
                  BienImmobilierModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrevious: json['hasPrevious'] as bool? ?? false,
    );

Map<String, dynamic> _$$BienImmobilierCollectionImplToJson(
        _$BienImmobilierCollectionImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'pageSize': instance.pageSize,
      'hasNext': instance.hasNext,
      'hasPrevious': instance.hasPrevious,
    };
