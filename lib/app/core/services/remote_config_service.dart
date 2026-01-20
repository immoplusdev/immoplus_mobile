// services/remote_config_service.dart
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  bool _initialized = false;

  // Clés des configurations (pour éviter les fautes de frappe)
  static const String forceUpgradeAppKey = 'force_upgrade_app_client';

  // Valeurs par défaut
  static final Map<String, dynamic> _defaults = {
    // update app
    forceUpgradeAppKey: false,
  };

  factory RemoteConfigService() {
    return _instance;
  }

  RemoteConfigService._internal();

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(seconds: 2),
      ));

      await _remoteConfig.setDefaults(_defaults);
      await _remoteConfig.fetchAndActivate();

      _initialized = true;
    } catch (e) {
      debugPrint('Error initializing Remote Config: $e');
    }
  }

  // Méthodes génériques pour récupérer les valeurs
  bool getBool(String key) {
    try {
      return _remoteConfig.getBool(key);
    } catch (e) {
      debugPrint('Error getting bool for key $key: $e');
      return _defaults[key] ?? false;
    }
  }

  String getString(String key) {
    try {
      return _remoteConfig.getString(key);
    } catch (e) {
      debugPrint('Error getting string for key $key: $e');
      return _defaults[key] ?? '';
    }
  }

  double getDouble(String key) {
    try {
      return _remoteConfig.getDouble(key);
    } catch (e) {
      debugPrint('Error getting double for key $key: $e');
      return _defaults[key] ?? 0.0;
    }
  }

  // Méthodes spécifiques pour les fonctionnalités

  // update app
  bool get forceUpgradeApp => getBool(forceUpgradeAppKey);
}
