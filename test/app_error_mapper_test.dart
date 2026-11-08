import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immoplus/app/core/error/app_error.dart';
import 'package:immoplus/app/core/error/app_error_mapper.dart';

DioException _dioError({
  int? status,
  Object? data,
  DioExceptionType type = DioExceptionType.badResponse,
  Map<String, dynamic>? extra,
  Map<String, List<String>>? headers,
}) {
  final options = RequestOptions(path: '/x', extra: extra ?? {});
  return DioException(
    requestOptions: options,
    type: type,
    response: status == null
        ? null
        : Response(
            requestOptions: options,
            statusCode: status,
            data: data,
            headers: Headers.fromMap(headers ?? {}),
          ),
  );
}

void main() {
  group('AppErrorMapper', () {
    test('timeouts et perte de connexion → NetworkError retryable', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.connectionError,
      ]) {
        final error = AppErrorMapper.fromDio(_dioError(type: type));
        expect(error, isA<NetworkError>());
        expect(error.retryable, isTrue);
      }
    });

    test('401 sans code → UnauthorizedError (session expirée)', () {
      final error = AppErrorMapper.fromDio(_dioError(status: 401, data: {}));
      expect(error, isA<UnauthorizedError>());
    });

    test('401 mauvais identifiants → BusinessError, pas une session expirée',
        () {
      for (final code in [
        'AUTHENTICATION_FAILED',
        'INVALID_PASSWORD',
        'WRONG_PASSWORD',
        'INVALID_OTP',
      ]) {
        final error = AppErrorMapper.fromDio(_dioError(
          status: 401,
          data: {'code': code, 'message': 'Identifiants incorrects.'},
        ));
        expect(error, isA<BusinessError>(), reason: code);
        expect(error.message, 'Identifiants incorrects.');
      }
    });

    test('403 → ForbiddenError avec le message du back', () {
      final error = AppErrorMapper.fromDio(_dioError(
        status: 403,
        data: {
          'code': 'FORBIDDEN',
          'message': 'Votre type de compte ne vous autorise pas.',
        },
      ));
      expect(error, isA<ForbiddenError>());
      expect(error.message, contains('type de compte'));
    });

    test('requête annulée → erreur silencieuse', () {
      final error =
          AppErrorMapper.fromDio(_dioError(type: DioExceptionType.cancel));
      expect(error.silent, isTrue);
    });

    test('404 → NotFoundError avec message métier', () {
      final error = AppErrorMapper.fromDio(_dioError(
        status: 404,
        data: {'code': 'RESOURCE_NOT_FOUND', 'message': 'Logement retiré.'},
      ));
      expect(error, isA<NotFoundError>());
      expect(error.message, 'Logement retiré.');
      expect(error.code, 'RESOURCE_NOT_FOUND');
    });

    test('5xx → ServerError sans jamais reprendre le message serveur', () {
      final error = AppErrorMapper.fromDio(_dioError(
        status: 500,
        data: {'message': 'NullPointerException at line 42'},
      ));
      expect(error, isA<ServerError>());
      expect(error.message, isNull);
      expect(error.retryable, isTrue);
    });

    test('fieldErrors (map) → ValidationError', () {
      final error = AppErrorMapper.fromDio(_dioError(
        status: 400,
        data: {
          'fieldErrors': {
            'email': ['Email invalide']
          }
        },
      ));
      expect(error, isA<ValidationError>());
      expect((error as ValidationError).fieldError('email'), 'Email invalide');
    });

    test('fieldErrors (liste field/message) → ValidationError', () {
      final error = AppErrorMapper.fromDio(_dioError(
        status: 422,
        data: {
          'fieldErrors': [
            {'field': 'phoneNumber', 'message': 'Numéro invalide'}
          ]
        },
      ));
      expect((error as ValidationError).fieldError('phoneNumber'),
          'Numéro invalide');
    });

    test('ancien format : message en liste → premier message', () {
      final error = AppErrorMapper.fromDio(_dioError(
        status: 422,
        data: {
          'message': ['Le champ est requis', 'autre']
        },
      ));
      expect(error, isA<ValidationError>());
      expect(error.message, 'Le champ est requis');
    });

    test('400 avec code métier → BusinessError, requestId et retryable', () {
      final error = AppErrorMapper.fromDio(_dioError(
        status: 400,
        data: {
          'code': 'PAYMENT_DECLINED',
          'message': 'Paiement refusé.',
          'requestId': 'req-1',
          'retryable': true,
        },
      ));
      expect(error, isA<BusinessError>());
      expect(error.code, 'PAYMENT_DECLINED');
      expect(error.requestId, 'req-1');
      expect(error.retryable, isTrue);
    });

    test('requestId repris de l\'en-tête x-request-id', () {
      final error = AppErrorMapper.fromDio(_dioError(
        status: 500,
        data: {},
        headers: {
          'x-request-id': ['hdr-9']
        },
      ));
      expect(error.requestId, 'hdr-9');
    });

    test('requête marquée silencieuse → erreur silencieuse', () {
      final error = AppErrorMapper.fromDio(_dioError(
        status: 500,
        data: {},
        extra: {AppErrorMapper.silentKey: true},
      ));
      expect(error.silent, isTrue);
    });

    test('from() réutilise l\'AppError portée par la DioException', () {
      const attached = BusinessError(code: 'X');
      final dio = _dioError(status: 400, data: {}).copyWith(error: attached);
      expect(AppErrorMapper.from(dio), same(attached));
    });

    test('from() : objet inconnu → UnknownError', () {
      expect(AppErrorMapper.from(StateError('boom')), isA<UnknownError>());
    });
  });
}
