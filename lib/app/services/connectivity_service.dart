import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';

class ConnectinityService {
  static ConnectivityResult? savecState;
  static StreamSubscription<List<ConnectivityResult>>? subscription;
  static checkConnectivity() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectionState.done) &&
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
      EasyLoading.init();
      subscription = Connectivity()
          .onConnectivityChanged
          .listen((List<ConnectivityResult> result) {
        if (savecState == ConnectivityResult.none) {
          EasyLoading.instance
            ..backgroundColor = Colors.green
            ..textColor = Colors.white
            ..radius = 20;
          EasyLoading.showToast('Connexion internet rétablie',
              toastPosition: EasyLoadingToastPosition.bottom);
        }
        inspect(result);
        // Received changes in available connectivity types!
        if (result.contains(ConnectivityResult.mobile)) {
          // Mobile network available.
        } else if (result.contains(ConnectivityResult.wifi)) {
          // Wi-fi is available.
          // Note for Android:
          // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
        } else if (result.contains(ConnectivityResult.ethernet)) {
          // Ethernet connection available.
        } else if (result.contains(ConnectivityResult.vpn)) {
          // Vpn connection active.
          // Note for iOS and macOS:
          // There is no separate network interface type for [vpn].
          // It returns [other] on any device (also simulator)
        } else if (result.contains(ConnectivityResult.bluetooth)) {
          // Bluetooth connection available.
        } else if (result.contains(ConnectivityResult.other)) {
          // Connected to a network which is not in the above mentioned networks.
        } else if (result.contains(ConnectivityResult.none)) {
          // No available network types
          savecState = result.first;
          _showErorConnexion();
          log('No available network types');
        } else {
          savecState = result.first;
          _showErorConnexion();
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  static _showErorConnexion() {
    EasyLoading.instance
      ..backgroundColor = Colors.red
      ..textColor = Colors.white
      ..radius = 20;

    EasyLoading.showToast(
      'Problème de connexion internet',
      toastPosition: EasyLoadingToastPosition.bottom,
    );
  }

  static stop() async {
    if (subscription != null) {
      await subscription!.cancel();
    }
  }

  static pause() async {
    if (subscription != null) {
      subscription!.pause();
    }
  }
}
