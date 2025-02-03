import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:immoplus/app/core/network/interceptors/request_interceptor.dart';
import 'package:injectable/injectable.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

@module
abstract class DioConfig {
  @lazySingleton
  Dio dio(AuthInterceptor authInterceptor, ErrorInterceptor errorInterceptor,
      RequestInterceptor requestInterceptor) {
    //just config
    final dio = Dio(BaseOptions(
        baseUrl: dotenv.env['API_PRO_URL'] ?? '',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
        }));
    dio.interceptors
        .addAll([authInterceptor, errorInterceptor, requestInterceptor]);
    return dio;
  }
}
