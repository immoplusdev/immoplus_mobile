import 'package:dio/dio.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/local/user_model_schema.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthInterceptor extends Interceptor {
  SessionManager sessionManager;
  AuthInterceptor(this.sessionManager);
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    UserModelSchema? data = await sessionManager.getCurrentUser();

    if (data != null) {
      final token = data.accessToken;
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
