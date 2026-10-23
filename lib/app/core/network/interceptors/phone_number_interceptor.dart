import 'package:dio/dio.dart';
import 'package:immoplus/app/utils/phone_number_handler.dart';

/// Filet de sécurité : retire le '+' des numéros de téléphone envoyés à l'API,
/// quel que soit l'écran à l'origine de la requête.
class PhoneNumberInterceptor extends Interceptor {
  static const _keys = {'phoneNumber', 'phone_number'};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final data = options.data;
    if (data is Map) {
      for (final key in _keys) {
        final value = data[key];
        if (value is String && value.trim().startsWith('+')) {
          data[key] = PhoneNumberHandler.formatPhoneNumber(value);
        }
      }
    }
    super.onRequest(options, handler);
  }
}
