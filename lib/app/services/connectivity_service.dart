import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:immoplus/app/utils/utils.dart';

class ConnectinityService {
  static bool _isInitialized = false;
  static bool? _wasOnline;
  static StreamSubscription<List<ConnectivityResult>>? subscription;

  static checkConnectivity() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none) &&
        NavigationService.navigatorKey.currentContext != null) {
      AppDialog.info(
          content:
              'Problèmes de connexion veuillez vérifier votre connexion internet.',
          icon: const Icon(
            CupertinoIcons.wifi_exclamationmark,
            size: 50,
            color: Colors.red,
          ));
    }
  }

  static listen() {
    try {
      subscription = Connectivity()
          .onConnectivityChanged
          .listen((List<ConnectivityResult> result) {
        final bool isCurrentlyOnline = Utils.isOnline(result);

        // Premier appel au lancement : on enregistre juste l'état initial sans afficher de toast
        if (!_isInitialized) {
          _isInitialized = true;
          _wasOnline = isCurrentlyOnline;
          return;
        }

        // Détection d'un vrai changement d'état
        if (_wasOnline == true && !isCurrentlyOnline) {
          _wasOnline = false;
          _showErorConnexion();
          log('Connexion internet perdue');
        } else if (_wasOnline == false && isCurrentlyOnline) {
          _wasOnline = true;
          ToastUtils.showSuccess(title: 'Connexion internet rétablie');
          log('Connexion internet rétablie');
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  static _showErorConnexion() {
    ToastUtils.showError(title: 'Problème de connexion internet');
  }

  static stop() async {
    if (subscription != null) {
      await subscription!.cancel();
    }
    _isInitialized = false;
    _wasOnline = null;
  }

  static pause() async {
    if (subscription != null) {
      subscription!.pause();
    }
  }
}

