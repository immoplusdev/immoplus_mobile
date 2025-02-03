// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_model_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentsModelCollectionImpl _$$PaymentsModelCollectionImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentsModelCollectionImpl(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => PaymentItentData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrevious: json['hasPrevious'] as bool? ?? false,
    );

Map<String, dynamic> _$$PaymentsModelCollectionImplToJson(
        _$PaymentsModelCollectionImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'pageSize': instance.pageSize,
      'hasNext': instance.hasNext,
      'hasPrevious': instance.hasPrevious,
    };
