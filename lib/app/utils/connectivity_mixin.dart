import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/utils/utils.dart';

mixin ConnectivityMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  static bool _isDialogShowing = false;

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
          // Si le dialogue d'erreur est affiché, le fermer automatiquement
          if (_isDialogShowing &&
              NavigationService.navigatorKey.currentContext != null) {
            Navigator.of(NavigationService.navigatorKey.currentContext!,
                    rootNavigator: true)
                .maybePop();
            _isDialogShowing = false;
          }
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

  /// Use this method to show a popup when a request fails or when connection is unavailable.
  /// Uses an atomic flag to strictly avoid stacked/duplicate dialogs.
  Future<void> showConnectionErrorDialog([dynamic error]) async {
    // 1. Si une erreur explicite est fournie et qu'il s'agit d'une erreur HTTP (ex: 404),
    // on ne doit PAS afficher le dialogue "Vérifiez votre connexion internet".
    if (error != null && !Utils.isNetworkError(error)) {
      return;
    }

    // 2. Si aucune erreur n'a été spécifiée, vérifier si l'appareil est réellement hors-ligne
    if (error == null) {
      final hasConnection = await Utils.hasInternetConnection();
      if (hasConnection) {
        // L'appareil est connecté à internet, ce n'est donc pas une perte de réseau
        return;
      }
    }

    // 3. Verrou synchrone immédiat contre les ouvertures concurrentes
    if (_isDialogShowing) return;
    _isDialogShowing = true;

    try {
      final context = NavigationService.navigatorKey.currentContext;
      if (context == null || !context.mounted) {
        _isDialogShowing = false;
        return;
      }

      await AppDialog.show(
        title: "Erreur de chargement",
        description: "Veuillez vérifier votre connexion internet et réessayer.",
        primaryButtonText: "Fermer",
        barrierDismissible: true,
        onPrimary: () {
          _isDialogShowing = false;
        },
      );
    } catch (_) {
      // Ignorer les erreurs d'affichage
    } finally {
      // 4. Le verrou est libéré dès que la boîte de dialogue est fermée
      _isDialogShowing = false;
    }
  }
}
