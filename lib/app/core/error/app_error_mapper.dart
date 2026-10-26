import 'dart:io';

import 'package:dio/dio.dart';
import 'package:immoplus/app/core/error/app_error.dart';
import 'package:immoplus/app/data/enums/api_error_code.dart';

/// Convertit une erreur technique en [AppError], selon le contrat d'erreur
/// de l'API : `code`, `message`, `fieldErrors?`, `retryable?`, `requestId`.
///
/// Tolère l'ancien format (Nest/class-validator : `message` sous forme de
/// liste de chaînes) tant que le back n'a pas migré.
class AppErrorMapper {
  const AppErrorMapper._();

  /// Clé d'`Options.extra` : marque une requête de fond (aucun feedback).
  static const silentKey = 'silent';

  static const _requestIdHeader = 'x-request-id';

  /// 401 liés à une saisie (mauvais mot de passe, code OTP) : ce n'est pas une
  /// session expirée, mais un refus métier à expliquer à l'utilisateur.
  static final _credentialCodes = {
    ApiErrorCode.authenticationFailed.value,
    ApiErrorCode.invalidPassword.value,
    ApiErrorCode.wrongPassword.value,
    ApiErrorCode.invalidOtp.value,
  };

  /// Extrait l'[AppError] d'une erreur quelconque. Une `DioException` déjà
  /// traitée par l'intercepteur expose son [AppError] dans `error`.
  static AppError from(Object error) {
    if (error is AppError) return error;
    if (error is DioException) {
      final attached = error.error;
      if (attached is AppError) return attached;
      return fromDio(error);
    }
    return UnknownError(cause: error);
  }

  static AppError fromDio(DioException error, {bool forceSilent = false}) {
    final silent = forceSilent || error.requestOptions.extra[silentKey] == true;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkError(cause: error, silent: silent);
      case DioExceptionType.cancel:
        // Requête annulée volontairement : jamais de feedback.
        return UnknownError(cause: error, silent: true);
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NetworkError(cause: error, silent: silent);
        }
      default:
        break;
    }

    final response = error.response;
    if (response == null) return UnknownError(cause: error, silent: silent);

    final status = response.statusCode;
    final body = response.data is Map ? response.data as Map : const {};
    final code = body['code']?.toString();
    final requestId = body['requestId']?.toString() ??
        response.headers.value(_requestIdHeader);
    final retryable = body['retryable'] == true;
    final fieldErrors = _parseFieldErrors(body);
    final message = _parseMessage(body);

    if (status == 403) {
      return ForbiddenError(
        message: message,
        code: code,
        requestId: requestId,
        statusCode: status,
        silent: silent,
        cause: error,
      );
    }
    if (status == 401 && !_credentialCodes.contains(code)) {
      return UnauthorizedError(
        message: message,
        code: code,
        requestId: requestId,
        statusCode: status,
        silent: silent,
        cause: error,
      );
    }
    if (status == 404) {
      return NotFoundError(
        message: message,
        code: code,
        requestId: requestId,
        statusCode: status,
        silent: silent,
        cause: error,
      );
    }
    if (status != null && status >= 500) {
      return ServerError(
        code: code,
        requestId: requestId,
        statusCode: status,
        retryable: true,
        silent: silent,
        cause: error,
      );
    }
    if (fieldErrors.isNotEmpty || status == 422) {
      return ValidationError(
        fieldErrors: fieldErrors,
        message: message,
        code: code,
        requestId: requestId,
        statusCode: status,
        silent: silent,
        cause: error,
      );
    }
    if (status != null && status >= 400) {
      return BusinessError(
        message: message,
        code: code,
        requestId: requestId,
        statusCode: status,
        retryable: retryable,
        silent: silent,
        cause: error,
      );
    }
    return UnknownError(
      code: code,
      requestId: requestId,
      statusCode: status,
      silent: silent,
      cause: error,
    );
  }

  /// Message sûr : chaîne simple, ou liste de messages (ancien format).
  static String? _parseMessage(Map body) {
    final message = body['message'];
    if (message is String && message.trim().isNotEmpty) return message.trim();
    if (message is List && message.isNotEmpty) return message.first.toString();
    return null;
  }

  /// `fieldErrors` : `{champ: [messages]}` ou `[{field, message}]`.
  static Map<String, List<String>> _parseFieldErrors(Map body) {
    final raw = body['fieldErrors'];
    final result = <String, List<String>>{};
    if (raw is Map) {
      raw.forEach((key, value) {
        final messages = value is List
            ? value.map((e) => e.toString()).toList()
            : [value.toString()];
        result[key.toString()] = messages;
      });
    } else if (raw is List) {
      for (final item in raw) {
        if (item is Map && item['field'] != null) {
          result
              .putIfAbsent(item['field'].toString(), () => [])
              .add(item['message']?.toString() ?? '');
        }
      }
    }
    return result;
  }
}
