// auth_redirect_service.dart
import 'package:immoplus/app/core/type/auth_redirect_data.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthRedirectService {
  AuthRedirectData? _redirectData;

  void set(AuthRedirectData? data) => _redirectData = data;
  void clear() => _redirectData = null;
  AuthRedirectData? get() => _redirectData;
}
