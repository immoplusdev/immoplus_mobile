import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final method = options.method.toUpperCase();
      final url = _buildFullUrl(options);
      _logBox(
        title: 'http-request',
        method: method,
        url: url,
        data: options.data,
      );
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final method = response.requestOptions.method.toUpperCase();
      final url = _buildFullUrl(response.requestOptions);
      final status = response.statusCode ?? 200;
      final statusMessage = response.statusMessage ?? 'OK';
      _logBox(
        title: 'http-response',
        method: method,
        url: url,
        status: status,
        message: statusMessage,
        data: response.data,
      );
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final method = err.requestOptions.method.toUpperCase();
      final url = _buildFullUrl(err.requestOptions);
      final status = err.response?.statusCode;
      final statusMessage =
          err.response?.statusMessage ?? err.message ?? 'Error';
      _logBox(
        title: 'http-error',
        method: method,
        url: url,
        status: status,
        message: statusMessage,
        data: err.response?.data,
      );
    }
    super.onError(err, handler);
  }

  String _buildFullUrl(RequestOptions options) {
    final uri = options.uri.toString();
    if (uri.isNotEmpty) return uri;
    return '${options.baseUrl}${options.path}';
  }

  void _logBox({
    required String title,
    required String method,
    required String url,
    int? status,
    String? message,
    dynamic data,
  }) {
    const border =
        '──────────────────────────────────────────────────────────────────────────────────────────────────────────────';
    print('┌$border');
    print('│ [$title] [$method] $url');
    if (status != null) {
      print('│ Status: $status');
    }
    if (message != null && message.isNotEmpty) {
      print('│ Message: $message');
    }
    if (data != null) {
      final formatted = _formatData(data);
      if (formatted.isNotEmpty) {
        final lines = formatted.split('\n');
        print('│ Data: ${lines.first}');
        for (var i = 1; i < lines.length; i++) {
          print('│ ${lines[i]}');
        }
      }
    }
    print('└$border');
  }

  String _formatData(dynamic data) {
    if (data == null) return '';
    try {
      if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      }
      if (data is String) {
        final parsed = jsonDecode(data);
        return const JsonEncoder.withIndent('  ').convert(parsed);
      }
    } catch (_) {}
    return data.toString();
  }
}
