import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/services/permission_request_queue.dart';
import 'package:immoplus/app/core/services/navigation_service.dart';
import 'package:immoplus/app/core/services/notification_service.dart';
import 'package:immoplus/app/features/notification/widgets/notification_actif_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Moments clés où l'on propose d'activer les notifications.
enum NotificationPromptMoment {
  /// Fin de l'onboarding : toujours proposé tant que non activé.
  onboarding,

  /// Arrivée sur l'accueil : à chaque ouverture tant que non activé.
  home,

  /// Juste après l'envoi d'une demande de réservation.
  bookingRequested,

  /// Juste après une connexion réussie.
  login,
}

/// Affiche le sheet d'activation des notifications tant que la permission
/// système n'est pas accordée, à des moments clés de l'application.
///
/// Après « Peut-être plus tard », il revient à chaque moment clé (connexion,
/// demande de réservation) et à chaque arrivée sur l'accueil, avec au moins
/// [_minGap] entre deux affichages.
class NotificationPermissionService {
  NotificationPermissionService._();

  static const _statusKey = 'actif_notif_status';
  static const _lastShownKey = 'actif_notif_last_shown_at';
  static const _accepted = 'accepted';
  static const _maybeLater = 'maybe_later';
  static const _minGap = Duration(seconds: 30);

  static bool _isShowing = false;

  static Future<bool> isEnabled() async =>
      (await Permission.notification.status).isGranted;

  static Future<bool> _shouldShow(NotificationPromptMoment moment) async {
    final prefs = await SharedPreferences.getInstance();
    if (await isEnabled()) {
      await prefs.setString(_statusKey, _accepted);
      return false;
    }
    if (moment == NotificationPromptMoment.onboarding) return true;

    final lastShown = prefs.getInt(_lastShownKey);
    if (lastShown == null) return true;
    final elapsed = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(lastShown),
    );
    // Évite d'enchaîner deux sheets (ex: connexion puis accueil).
    return elapsed >= _minGap;
  }

  /// Propose le sheet si nécessaire. Sans [context], utilise le navigateur
  /// racine. Retourne quand le sheet est fermé (ou n'a pas été affiché).
  static Future<void> promptIfNeeded({
    BuildContext? context,
    required NotificationPromptMoment moment,
    Duration delay = Duration.zero,
  }) async {
    if (_isShowing) return;
    try {
      if (delay > Duration.zero) await Future.delayed(delay);
      if (!await _shouldShow(moment)) return;

      final ctx = context != null && context.mounted
          ? context
          : NavigationService.navigatorKey.currentContext;
      if (ctx == null || !ctx.mounted) return;

      _isShowing = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastShownKey, DateTime.now().millisecondsSinceEpoch);

      if (!ctx.mounted) return;
      await showModalBottomSheet<void>(
        context: ctx,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withValues(alpha: 0.6),
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (sheetCtx) => NotificationActifSheet(
          onAccept: () {
            Navigator.of(sheetCtx).pop();
            unawaited(_enable());
          },
          onMaybeLater: () async {
            Navigator.of(sheetCtx).pop();
            await prefs.setString(_statusKey, _maybeLater);
          },
        ),
      );
    } catch (e) {
      log('⚠️ Notification prompt error: $e', name: 'NOTIF_PERMISSION');
    } finally {
      _isShowing = false;
    }
  }

  static Future<void> _enable() async {
    final prefs = await SharedPreferences.getInstance();
    var status = await Permission.notification.status;

    // Refusé définitivement : seul l'écran de réglages permet de l'activer.
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return;
    }

    if (!status.isGranted) {
      await PermissionRequestQueue.run(
        getIt<NotificationService>().pushProvider.requestPermission,
      );
      status = await Permission.notification.status;
    }

    if (status.isGranted) {
      await prefs.setString(_statusKey, _accepted);
      await getIt<NotificationService>().suscribeCurrentUser();
    }
  }
}
