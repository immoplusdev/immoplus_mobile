import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../utils/request_utils.dart';

@lazySingleton
class RequestInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      log(options.method, name: 'METHOD');
      log("${options.baseUrl}${options.path} ", name: 'URL');
      String header =
          RequestUtils.addIndentation(options.headers.toString(), 2);
      log(header, name: 'HEADER');
      String jsonString =
          RequestUtils.addIndentation(options.data.toString(), 2);
      log(jsonString, name: 'BODY DATA');
      String param =
          RequestUtils.addIndentation(options.queryParameters.toString(), 2);
      log(param, name: 'PARAMS DATA');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    inspect(response);
    log(response.statusCode.toString(), name: 'RESPONSE STATUS');
    String jsonString =
        RequestUtils.addIndentation(response.data.toString(), 2);
    log(jsonString, name: 'RESPONSE DATA');
    super.onResponse(response, handler);
  }
}
