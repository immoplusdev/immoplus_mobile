import 'package:immoplus/app/core/error/error_feedback.dart';
import 'package:immoplus/app/core/error/error_context.dart';
import 'package:immoplus/app/core/error/app_error.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:immoplus/app/utils/utils.dart';

mixin ConnectivityMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Override this method to define what happens when connection is restored.
  void onConnectionRestored();

  /// Call this in `initState()`
  void setupConnectivityListener() {
    // Vérification initiale immédiate dès l'ouverture de la page
    Utils.hasInternetConnection().then((hasConnection) {
      if (!hasConnection && mounted) {
        showConnectionErrorDialog();
      }
    });

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) async {
      final hasConnection = Utils.isOnline(results);
      if (hasConnection) {
        // Wait a bit to ensure the network is actually ready for requests
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          ErrorFeedback.connectionRestored();
          onConnectionRestored();
        }
      } else {
        // Aucune connexion n'est active -> afficher le message d'erreur
        if (mounted) {
          showConnectionErrorDialog();
        }
      }
    });
  }

  /// Call this in `dispose()`
  void disposeConnectivityListener() {
    _connectivitySubscription?.cancel();
  }

  /// Présente une erreur de chargement via `ErrorFeedback` : dialogue « Pas
  /// de connexion » (fermé et relancé au retour du réseau) ou dialogue
  /// contextualisé pour une erreur d'API. Sans [error], ne fait quelque chose
  /// que si l'appareil est réellement hors ligne.
  Future<void> showConnectionErrorDialog([dynamic error]) async {
    if (error is Object) {
      ErrorFeedback.show(error, context: ErrorContext.feedLoad);
      return;
    }
    if (await Utils.hasInternetConnection()) return;
    ErrorFeedback.present(const NetworkError(), context: ErrorContext.feedLoad);
  }
}
