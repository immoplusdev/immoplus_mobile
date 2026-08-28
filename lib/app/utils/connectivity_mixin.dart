import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';

mixin ConnectivityMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Override this method to define what happens when connection is restored.
  void onConnectionRestored();

  /// Call this in `initState()`
  void setupConnectivityListener() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) async {
      if (results.any((r) => r != ConnectivityResult.none)) {
        // Wait a bit to ensure the network is actually ready for requests
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          onConnectionRestored();
        }
      }
    });
  }

  /// Call this in `dispose()`
  void disposeConnectivityListener() {
    _connectivitySubscription?.cancel();
  }

  static bool _isDialogShowing = false;

  /// Use this method to show a popup when a request fails due to connection error.
  /// It checks the REAL network state via connectivity_plus before showing anything.
  void showConnectionErrorDialog() async {
    final results = await Connectivity().checkConnectivity();
    final hasConnection = results.any((r) => r != ConnectivityResult.none);

    // Si l'utilisateur a une connexion, ce n'est pas un problème réseau (ex: 404, 500).
    // On ne montre rien, c'est géré ailleurs.
    if (hasConnection) return;

    if (_isDialogShowing) return;
    _isDialogShowing = true;

    AppDialog.show(
      title: "Erreur de chargement",
      description: "Veuillez vérifier votre connexion internet et réessayer.",
      primaryButtonText: "Fermer",
      onPrimary: () {
        _isDialogShowing = false;
      },
    );

    // Reset after 2 seconds to allow future dialogs, but prevent simultaneous ones.
    Future.delayed(const Duration(seconds: 2), () {
      _isDialogShowing = false;
    });
  }
}
