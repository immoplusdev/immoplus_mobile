// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservations_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReservationsCollectionImpl _$$ReservationsCollectionImplFromJson(
        Map<String, dynamic> json) =>
    _$ReservationsCollectionImpl(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => ReservationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 10,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrevious: json['hasPrevious'] as bool? ?? false,
    );

Map<String, dynamic> _$$ReservationsCollectionImplToJson(
        _$ReservationsCollectionImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'pageSize': instance.pageSize,
      'totalCount': instance.totalCount,
      'hasNext': instance.hasNext,
      'hasPrevious': instance.hasPrevious,
    };
