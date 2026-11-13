import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:immoplus/app/core/services/app_version_service.dart';
import 'package:immoplus/app/core/services/crashlytics_service.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implémentation concrète de [CrashlyticsService] s'appuyant sur Firebase Crashlytics.
@LazySingleton(as: CrashlyticsService)
class FirebaseCrashlyticsServiceImpl implements CrashlyticsService {
  static const String _kConsentKey = 'crashlytics_collection_consent';

  final FirebaseCrashlytics _crashlytics;

  FirebaseCrashlyticsServiceImpl()
      : _crashlytics = FirebaseCrashlytics.instance;

  @visibleForTesting
  FirebaseCrashlyticsServiceImpl.withInstance(this._crashlytics);

  @override
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final consent = prefs.getBool(_kConsentKey);

    // Par défaut activé selon la politique de consentement de l'application
    final isEnabled = consent ?? true;
    await _crashlytics.setCrashlyticsCollectionEnabled(isEnabled);

    // Enregistre les métadonnées globales statiques non sensibles
    await _setDefaultCustomKeys();
  }

  Future<void> _setDefaultCustomKeys() async {
    try {
      final platform = Platform.isIOS ? 'ios' : 'android';
      await _crashlytics.setCustomKey('device_platform', platform);

      final fullVersion = await AppVersionService.getFullVersion();
      await _crashlytics.setCustomKey('app_version', fullVersion);
    } catch (_) {
      // Évite tout blocage en cas d'erreur de lecture de version
    }
  }

  @override
  Future<void> setCollectionEnabled(bool enabled) async {
    await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kConsentKey, enabled);
  }

  @override
  Future<bool> isCollectionEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kConsentKey) ??
        _crashlytics.isCrashlyticsCollectionEnabled;
  }

  @override
  Future<void> setUserId(String userId) async {
    // Uniquement l'ID technique interne anonyme, jamais d'email/téléphone/nom
    await _crashlytics.setUserIdentifier(userId);
  }

  @override
  Future<void> clearUserId() async {
    await _crashlytics.setUserIdentifier('');
  }

  @override
  Future<void> log(String message) async {
    final sanitized = _sanitizeText(message);
    await _crashlytics.log(sanitized);
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    if (_isSensitiveKey(key)) return;
    await _crashlytics.setCustomKey(key, _sanitizeValue(value));
  }

  @override
  Future<void> recordNonFatalError({
    required dynamic exception,
    required StackTrace? stackTrace,
    required String screen,
    required String feature,
    String? errorType,
    String? reason,
    Map<String, Object>? additionalContext,
  }) async {
    // Filtre les erreurs bénignes ou annulées par l'utilisateur
    if (_isBenignOrIgnored(exception)) return;

    try {
      await _crashlytics.setCustomKey('screen', _sanitizeText(screen));
      await _crashlytics.setCustomKey('feature', _sanitizeText(feature));

      if (errorType != null) {
        await _crashlytics.setCustomKey('error_type', _sanitizeText(errorType));
      }

      final fullVersion = await AppVersionService.getFullVersion();
      await _crashlytics.setCustomKey('app_version', fullVersion);

      if (additionalContext != null) {
        for (final entry in additionalContext.entries) {
          if (!_isSensitiveKey(entry.key)) {
            await _crashlytics.setCustomKey(
              entry.key,
              _sanitizeValue(entry.value),
            );
          }
        }
      }

      await _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason != null ? _sanitizeText(reason) : null,
        fatal: false,
      );
    } catch (_) {
      // Ne bloque jamais l'application si l'envoi de log échoue
    }
  }

  // ── Protection stricte contre l'envoi de données sensibles (PII) ─────────

  static final List<RegExp> _sensitivePatterns = [
    RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'), // emails
    RegExp(r'(\+?\d{8,15})'), // numéros de téléphone
    RegExp(
      r'(Bearer\s+[A-Za-z0-9\-._~+/]+=*)',
      caseSensitive: false,
    ), // JWT tokens
    RegExp(
      r'(token\s*[:=]\s*["\u0027]?[A-Za-z0-9\-._~+/]+)',
      caseSensitive: false,
    ),
  ];

  static const List<String> _forbiddenKeyKeywords = [
    'password',
    'pass',
    'token',
    'secret',
    'auth',
    'authorization',
    'email',
    'phone',
    'telephone',
    'kyc',
    'cni',
    'passport',
    'card',
    'pan',
    'cvv',
    'pin',
    'address',
    'conversation',
    'message',
  ];

  bool _isSensitiveKey(String key) {
    final lower = key.toLowerCase();
    return _forbiddenKeyKeywords.any((k) => lower.contains(k));
  }

  String _sanitizeText(String text) {
    var result = text;
    for (final pattern in _sensitivePatterns) {
      result = result.replaceAll(pattern, '[REDACTED]');
    }
    return result;
  }

  Object _sanitizeValue(Object value) {
    if (value is String) {
      return _sanitizeText(value);
    }
    return value;
  }

  bool _isBenignOrIgnored(dynamic exception) {
    final str = exception.toString().toLowerCase();
    if (str.contains('user_cancelled') ||
        str.contains('canceled') ||
        str.contains('cancelled') ||
        str.contains('abort')) {
      return true;
    }
    return false;
  }

  // ── Mécanisme de test DEV / QA (inactif en production) ───────────────────

  @override
  Future<void> triggerControlledNonFatalError() async {
    if (kReleaseMode) return;
    try {
      throw Exception('Immoplus Crashlytics Non-Fatal QA Test');
    } catch (e, stack) {
      await recordNonFatalError(
        exception: e,
        stackTrace: stack,
        screen: 'QATestScreen',
        feature: 'crashlytics_test',
        errorType: 'ControlledTestException',
        reason: 'Test non-fatal exception generated from QA tools',
        additionalContext: {
          'test_mode': true,
          'environment': 'qa_development',
        },
      );
    }
  }

  @override
  void triggerControlledAsyncError() {
    if (kReleaseMode) return;
    Future.delayed(const Duration(milliseconds: 100), () {
      throw StateError('Immoplus Crashlytics Unhandled Async QA Test Exception');
    });
  }

  @override
  void triggerControlledFatalCrash() {
    if (kReleaseMode) return;
    _crashlytics.crash();
  }
}
