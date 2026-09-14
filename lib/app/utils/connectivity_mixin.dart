import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';

mixin ConnectivityMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  static bool _isDialogShowing = false;

  /// Override this method to define what happens when connection is restored.
  void onConnectionRestored();

  /// Call this in `initState()`
  void setupConnectivityListener() {
    // Vérification initiale immédiate dès l'ouverture de la page
    Connectivity().checkConnectivity().then((results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (!hasConnection && mounted) {
        showConnectionErrorDialog();
      }
    });

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) async {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
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
    // 1. Verrou synchrone immédiat contre les ouvertures concurrentes
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
      // 2. Le verrou est libéré dès que la boîte de dialogue est fermée
      _isDialogShowing = false;
    }
  }
}
