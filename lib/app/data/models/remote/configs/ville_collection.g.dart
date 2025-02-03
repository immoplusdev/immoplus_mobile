// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ville_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VilleCollectionImpl _$$VilleCollectionImplFromJson(
        Map<String, dynamic> json) =>
    _$VilleCollectionImpl(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => VilleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 10,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrevious: json['hasPrevious'] as bool? ?? false,
    );

Map<String, dynamic> _$$VilleCollectionImplToJson(
        _$VilleCollectionImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'pageSize': instance.pageSize,
      'totalCount': instance.totalCount,
      'hasNext': instance.hasNext,
      'hasPrevious': instance.hasPrevious,
    };
