import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:immoplus/app/core/enums/push_notification_type.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/repositories/alert_repository.dart';
import 'package:immoplus/app/extensions/go_router_extensions.dart';

import 'package:immoplus/app/features/fast-track-book/reservation_pending_smart.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/firebase_options.dart';
import 'package:injectable/injectable.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

@lazySingleton
class NotificationService {
  SessionManager sessionManager;
  AlertRepository alertRepository;

  NotificationService(this.sessionManager, this.alertRepository);

  initConfig() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //Remove this method to stop OneSignal Debugging
    if (kDebugMode) {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    }
    OneSignal.initialize(dotenv.env['ONE_SIGNAL_KEY'] ?? '');
    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);
  }

  void setupNotificationListener() {
    /// Notification reçue quand l'app est ouverte
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      final data = event.notification.additionalData;
      getIt<AnalyticsService>().logNotificationReceived(
        notificationType: (data?['type'] as String?) ?? 'unknown',
        notificationId: event.notification.notificationId,
      );

      if (data != null) {
        final typeString = data['type'] as String?;
        final type = PushNotificationType.fromString(typeString);

        if (type == PushNotificationType.reservationAccepted) {
          log('🔔 Reservation accepted → update UI instantly + refresh',
              name: 'NOTIFICATION');
          ReservationPendingBanner.onPushReceived();
        }

        if (type == PushNotificationType.reservationRefused) {
          log('🔔 Reservation refused → update UI instantly + refresh',
              name: 'NOTIFICATION');
          ReservationPendingBanner.onPushReceived();
        }

        if (type == PushNotificationType.newProposal ||
            type == PushNotificationType.alert) {
          log('🔔 New proposal/alert → refresh badge count',
              name: 'NOTIFICATION');
          alertRepository.getImatchBadgeCount().then((count) {
            Constantes.imatchBadgeCount.value = count;
          });
        }
      }

      /// important : afficher quand même la notif
      event.preventDefault();
      event.notification.display();
    });

    /// Notification cliquée
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;
      getIt<AnalyticsService>().logNotificationTapped(
        notificationType: (data?['type'] as String?) ?? 'unknown',
        notificationId: event.notification.notificationId,
      );
      if (data != null) {
        final typeString = data['type'] as String?;
        final id = data['id']?.toString() ??
            data['alertId']?.toString() ??
            data['reservationId']?.toString();

        final type = PushNotificationType.fromString(typeString);

        if (sessionManager.currentUser == null) {
          log('🔔 Notification received but no user logged in',
              name: 'NOTIFICATION');
          return;
        }

        if (type != null) {
          final code = data['code']?.toString();
          final referenceId = data['referenceId']?.toString();
          final route = type.getRoute(id, code: code, referenceId: referenceId);

          if (route != null) {
            log('🔔 Navigation: ${AppRouter.router.currentLocation} → $route',
                name: 'NOTIFICATION');
            AppRouter.router.pushIfDifferent(route);
          } else {
            log('⚠️ Pas de route pour type: $typeString', name: 'NOTIFICATION');
          }
        }
      }
    });
  }

  suscribeCurrentUser() async {
    try {
      if (sessionManager.currentUser != null) {
        await OneSignal.login(sessionManager.currentUser!.userId ?? '');

        if (kDebugMode) {
          log(sessionManager.currentUser!.userId.toString(),
              name: 'SUSCRIPTION SUCCESS');
        }
      } else {
        log('SUBSCRIPTION FAILD NO USER');
      }
    } catch (e) {
      log('SUBSCRIPTION  ${e.toString()}');
    }
  }
}
