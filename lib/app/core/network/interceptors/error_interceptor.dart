import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/login_page/login_page.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:injectable/injectable.dart';
import 'package:toastification/toastification.dart';

import '../../services/navigation_service.dart';

@lazySingleton
class ErrorInterceptor extends Interceptor {
  SessionManager sessionManager;
  ErrorInterceptor(this.sessionManager);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      if (err.response?.statusCode == 401) {
        AppRouter.router.goNamed(LoginPage.name);
      }
      toastification.show(
        type: ToastificationType.error,
        context: NavigationService.navigatorKey
            .currentContext, // optional if you use ToastificationWrapper
        title: const Text("Oops, quelque chose s'est mal passé."),
        description: Text(_manageResponse(err.response!)),
        autoCloseDuration: const Duration(seconds: 5),

        showProgressBar: false,
        alignment: Alignment.bottomCenter,
        style: ToastificationStyle.flatColored,
      );
    } catch (e) {
      log(e.toString(), name: 'ERROR');
      inspect(e);
    }

    super.onError(err, handler);
  }

  _manageResponse(Response response) {
    if (response.data != null) {
      if (response.data['message'] != null) {
        return response.data['message'];
      }
    }

    return _getMessageFromStatusCode(response.statusCode);
  }

  _getMessageFromStatusCode(int? statusCode) {
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
        return "Une erreur inconnue s'est produite.";
    }
  }
}
