import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/logger/immo_logger.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/auth_service.dart';
import 'package:immoplus/app/data/enums/api_error_code.dart';
import 'package:immoplus/app/data/error/api_error_response.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:injectable/injectable.dart';

import '../../services/navigation_service.dart';

const _silentErrorCodes = {
  ApiErrorCode.jwtTokenExpired,
  ApiErrorCode.socialAccountNotFound,
};

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
    final isUserPrefPUT = err.requestOptions.method == 'PUT' &&
        err.requestOptions.path.contains('/user-preferences/me');

    final isBannerGet = err.requestOptions.method == 'GET' &&
        err.requestOptions.path.contains('/banners');

    final isBadgeCountGet = err.requestOptions.method == 'GET' &&
        err.requestOptions.path.contains('/alerts/badge-count');

    // Afficher le toast d'erreur (sauf pour token expiré qui sera géré par refresh) et social account not found
    if (!_silentErrorCodes.contains(apiErrorResponse?.errorCode) &&
        !_isActiveReservationBlock(err.response) &&
        !isUserPrefPUT &&
        !isBannerGet &&
        !isBadgeCountGet) {
      _showErrorToast(apiErrorResponse, err.response);
    }

    // Gérer la déconnexion si nécessaire
    if (apiErrorResponse?.requiresLogout == true) {
      await sessionManager.logout();
      return; // Pas besoin d'appeler super.onError après déconnexion
    }

    super.onError(err, handler);
  }

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

  /// Retourne true si c'est un blocage "réservation active" — géré par le modal dédié
  bool _isActiveReservationBlock(Response? response) {
    if (response?.statusCode != 400) return false;
    final data = response?.data;
    if (data is! Map) return false;
    final inner = data['data'];
    return inner is Map && inner['reservationId'] != null;
  }

  /// Affiche le toast d'erreur approprié
  void _showErrorToast(ApiErrorResponse? apiErrorResponse, Response? response) {
    final context = NavigationService.navigatorKey.currentContext;
    final message = apiErrorResponse?.message ?? _manageResponse(response);
    if (context == null) {
      Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    ToastUtils.showError(
      title: "Oops, quelque chose s'est mal passé.",
      description: message,
    );
  }

  _manageResponse(Response? response) {
    try {
      if (response?.data != null) {
        if (response?.data['message'] != null) {
          return response?.data['message'];
        }
      }
      return _getMessageFromStatusCode(response?.statusCode);
    } catch (e) {
      ImmoLogger.e("manageResponse", e);
      return _getMessageFromStatusCode(response?.statusCode);
    }
  }

  String _getMessageFromStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Nous avons rencontré une erreur lors du traitement de votre requête.';
      case 401:
        return "Non autorisé : Vous n'avez pas les permissions nécessaires.";
      case 403:
        return "Accès interdit : Vous n'êtes pas autorisé à accéder à cette ressource.";
      case 404:
        return "Ressource introuvable : La page que vous recherchez n'existe pas.";
      case 405:
        return "Méthode non autorisée : La méthode HTTP utilisée n'est pas supportée pour cette ressource.";
      case 500:
        return "Erreur interne du serveur : Une erreur inattendue s'est produite.";
      case 502:
        return "Bad Gateway : Le serveur a reçu une réponse invalide d'un serveur en amont.";
      case 503:
        return "Service indisponible : Le serveur est temporairement indisponible.";
      default:
        return "Une erreur inconnue ${statusCode != null ? "($statusCode)" : ""}) s'est produite. ";
    }
  }
}
