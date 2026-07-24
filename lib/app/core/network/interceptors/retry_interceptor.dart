import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryInterval;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryInterval = const Duration(seconds: 2),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;

    // Determine type of error
    final isConnectionError = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.connectionError;

    final isTimeout = err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout;

    // GET requests are idempotent and always safe to retry.
    // For other HTTP methods (POST, PUT, DELETE), we only retry if it failed to establish
    // a connection (the server hasn't received/processed any payload yet).
    final isGetRequest = requestOptions.method.toUpperCase() == 'GET';
    final shouldRetry = isConnectionError || (isTimeout && isGetRequest);

    if (shouldRetry) {
      // Track the retry attempts in the extra field of RequestOptions
      int retries = requestOptions.extra['retries'] ?? 0;

      if (retries < maxRetries) {
        retries++;
        requestOptions.extra['retries'] = retries;

        debugPrint(
            '[RetryInterceptor] Retrying request ${requestOptions.path} ($retries/$maxRetries) due to timeout/connection error...');

        // Exponential backoff delay
        await Future.delayed(retryInterval * retries);

        try {
          // Re-send the request
          final response = await dio.fetch(requestOptions);
          return handler.resolve(response);
        } on DioException catch (e) {
          // If the retry also fails, pass the error along or let subsequent attempts handle it
          return super.onError(e, handler);
        }
      }
    }

    super.onError(err, handler);
  }
}
