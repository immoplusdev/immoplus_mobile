import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/error/app_error_mapper.dart';
import 'package:immoplus/app/core/logger/immo_logger.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/auth_service.dart';
import 'package:immoplus/app/data/enums/api_error_code.dart';
import 'package:immoplus/app/data/error/api_error_response.dart';
import 'package:injectable/injectable.dart';

const _silentErrorCodes = {
  ApiErrorCode.jwtTokenExpired,
  ApiErrorCode.socialAccountNotFound,
};

/// Lectures de fond (polling, préchargement) : leurs échecs ne regardent pas
/// l'utilisateur. Seules les requêtes GET sont concernées, pour ne pas
/// masquer les erreurs d'une action (création, annulation…) sur la même URL.
const _silentBackgroundPaths = [
  '/user-preferences/me',
  '/banners',
  '/alerts/badge-count',
  '/me/push-installations',
  '/reverse-searches',
];

@lazySingleton
class ErrorInterceptor extends Interceptor {
  SessionManager sessionManager;
  ErrorInterceptor(this.sessionManager);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    inspect(err);

    // Parser la réponse d'erreur
    final apiErrorResponse = _parseErrorResponse(err.response);

    // Gestion spéciale du token expiré
    if (apiErrorResponse?.errorCode == ApiErrorCode.jwtTokenExpired) {
      final handled = await _handleTokenExpired(err, handler);
      if (handled) return; // Si traité avec succès, on s'arrête ici
    }

    // L'intercepteur n'affiche aucune UI : il convertit l'erreur technique en
    // AppError (portée par `err.error`) que la feature présente via
    // ErrorFeedbackCoordinator. Les requêtes de fond sont marquées silencieuses
    // (par défaut ici, ou via `Options(extra: {AppErrorMapper.silentKey: true})`).
    final requiresLogout = apiErrorResponse?.requiresLogout == true;
    final isSilent = requiresLogout ||
        _silentErrorCodes.contains(apiErrorResponse?.errorCode) ||
        _isBackgroundRead(err.requestOptions);
    final appError = AppErrorMapper.fromDio(err, forceSilent: isSilent);

    // Session invalide : déconnexion (et redirection) déjà gérées, donc aucun
    // retour supplémentaire. L'erreur est tout de même propagée pour que les
    // appelants ne restent pas bloqués sur un chargement infini.
    if (requiresLogout) await sessionManager.logout();

    handler.next(err.copyWith(error: appError));
  }

  bool _isBackgroundRead(RequestOptions options) =>
      options.method.toUpperCase() == 'GET' &&
      _silentBackgroundPaths.any(options.path.contains);

  /// Parse la réponse d'erreur de façon sécurisée
  ApiErrorResponse? _parseErrorResponse(Response? response) {
    try {
      if (response?.data != null && response!.data is Map<String, dynamic>) {
        return ApiErrorResponse.fromJson(response.data);
      }
    } catch (e, s) {
      log('Erreur lors du parsing de la réponse d\'erreur: $e $s',
          name: 'ERROR_INTERCEPTOR');
    }
    return null;
  }

  /// Gère spécifiquement l'expiration du token
  Future<bool> _handleTokenExpired(
      DioException err, ErrorInterceptorHandler handler) async {
    ImmoLogger.w('Token expiré, tentative de refresh');

    final refreshSuccess = await AuthService.refreshToken(sessionManager);

    if (refreshSuccess) {
      // Retry la requête avec le nouveau token
      try {
        final response = await getIt<Dio>().request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: Options(method: err.requestOptions.method),
        );
        handler.resolve(response);
        return true; // Indique que l'erreur a été traitée
      } catch (retryError) {
        log('Erreur lors du retry: $retryError', name: 'ERROR_INTERCEPTOR');
      }
    } else {
      log('Refresh token échoué', name: 'ERROR_INTERCEPTOR');
      // AuthService a déjà géré la déconnexion si nécessaire
    }

    return false; // Indique que l'erreur n'a pas pu être traitée
  }
}
