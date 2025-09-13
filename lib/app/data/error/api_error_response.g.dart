// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiErrorResponse _$ApiErrorResponseFromJson(Map<String, dynamic> json) =>
    ApiErrorResponse(
      statusCode: (json['statusCode'] as num).toInt(),
      message: json['message'] as String?,
      error: json['error'] as String?,
      code: json['code'] as String?,
      timestamp: json['timestamp'] as String?,
      path: json['path'] as String?,
    );

Map<String, dynamic> _$ApiErrorResponseToJson(ApiErrorResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'error': instance.error,
      'code': instance.code,
      'timestamp': instance.timestamp,
      'path': instance.path,
    };
