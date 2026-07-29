import 'package:dio/dio.dart';
import 'package:immoplus/app/core/network/interceptors/request_interceptor.dart';
import 'package:immoplus/app/core/network/interceptors/retry_interceptor.dart';
import 'package:immoplus/app/utils/request_path.dart';
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
        baseUrl: RequestPath.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
        }));
    dio.interceptors.addAll([
      authInterceptor,
      requestInterceptor,
      RetryInterceptor(dio: dio),
      errorInterceptor,
    ]);
    return dio;
  }
}
