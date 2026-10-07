import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/account_source.dart';
import 'package:immoplus/app/core/enums/push_notification_type.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:immoplus/app/core/services/push/push_message.dart';
import 'package:immoplus/app/core/services/push/push_provider.dart';
import 'package:immoplus/app/data/repositories/alert_repository.dart';
import 'package:immoplus/app/data/repositories/notification_repository.dart';
import 'package:immoplus/app/data/repositories/reverse_search_repository.dart';
import 'package:immoplus/app/extensions/go_router_extensions.dart';
import 'package:immoplus/app/features/fast-track-book/reservation_pending_smart.dart';
import 'package:immoplus/app/features/payment_module/paiement_status_page.dart';
import 'package:immoplus/app/features/suggest/logic/reverse_search_navigation.dart';
import 'package:immoplus/app/core/services/app_version_service.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/core/services/navigation_service.dart';
import 'package:immoplus/app/core/services/push/push_installation_service.dart';
import 'package:injectable/injectable.dart';

/// Service d'orchestration métier des notifications de haut niveau.
/// Découplé du fournisseur push sous-jacent via le contrat [PushProvider].
@lazySingleton
class NotificationService {
  final PushProvider pushProvider;
  final SessionManager sessionManager;
  final AlertRepository alertRepository;
  final NotificationRepository notificationRepository;
  final AnalyticsService analyticsService;
  final PushInstallationService pushInstallationService;

  bool _listenersConfigured = false;

  NotificationService(
    this.pushProvider,
    this.sessionManager,
    this.alertRepository,
    this.notificationRepository,
    this.analyticsService,
    this.pushInstallationService,
  );

  /// Renvoie l'identifiant unique d'installation persisté (UUID v4)
  Future<String> getPushInstallationId() =>
      pushInstallationService.getInstallationId();

  /// Initialise la configuration du fournisseur push
  Future<void> initConfig() async {
    await pushProvider.initialize();

    // Écoute du renouvellement de token
    pushProvider.onTokenRefresh.listen((newToken) {
      log('🔔 Push token refreshed: $newToken', name: 'NOTIFICATION_SERVICE');
      suscribeCurrentUser(token: newToken);
    });

    // Enregistre l'appareil si l'utilisateur est déjà connecté
    await suscribeCurrentUser();
  }

  /// Configure les écouteurs de notifications (Foreground, Background click, Terminated click)
  void setupNotificationListener() {
    if (_listenersConfigured) {
      log('🔔 Notification listeners already configured, skipping duplicate setup',
          name: 'NOTIFICATION_SERVICE');
      return;
    }
    _listenersConfigured = true;

    // 1. Notification reçue en premier plan
    pushProvider.onForegroundMessage.listen((PushMessage message) {
      final data = message.data;
      final typeString = data['type']?.toString();
      final type = PushNotificationType.fromString(typeString);

      log('🔔 Push received in foreground: ${message.messageId}, type: $typeString',
          name: 'NOTIFICATION_SERVICE');

      analyticsService.logNotificationReceived(
        notificationType: typeString ?? 'unknown',
        notificationId: message.messageId,
      );

      // Mises à jour d'état in-app instantanées
      if (type == PushNotificationType.reservationAccepted ||
          type == PushNotificationType.reservationRefused) {
        log('🔔 Reservation updated → refresh UI',
            name: 'NOTIFICATION_SERVICE');
        ReservationPendingBanner.onPushReceived();
      }

      if (type == PushNotificationType.newProposal ||
          type == PushNotificationType.alert) {
        log('🔔 New proposal/alert → refresh badge count',
            name: 'NOTIFICATION_SERVICE');
        alertRepository.getImatchBadgeCount().then((count) {
          Constantes.imatchBadgeCount.value = count;
        });
      }
    });

    // 2. Notification cliquée depuis l'arrière-plan
    pushProvider.onNotificationOpenedApp.listen((PushMessage message) {
      log('🔔 Push clicked from background: ${message.messageId}',
          name: 'NOTIFICATION_SERVICE');
      analyticsService.logNotificationTapped(
        notificationType: message.data['type']?.toString() ?? 'unknown',
        notificationId: message.messageId,
      );
      handleNotificationData(message.data);
    });

    // 3. Notification ayant ouvert l'application à froid (Terminated)
    pushProvider.getInitialMessage().then((PushMessage? message) {
      if (message != null) {
        log('🔔 Initial push message from terminated state: ${message.messageId}',
            name: 'NOTIFICATION_SERVICE');
        analyticsService.logNotificationTapped(
          notificationType: message.data['type']?.toString() ?? 'unknown',
          notificationId: message.messageId,
        );
        handleNotificationData(message.data);
      }
    });
  }

  /// Traitement du routage et des actions suite au clic sur une notification
  void handleNotificationData(Map<String, dynamic> data) {
    log("handleNotificationData data: $data");
    final typeString = data['type']?.toString();
    final id = data['id']?.toString() ??
        data['alertId']?.toString() ??
        data['reservationId']?.toString() ??
        data['conversationId']?.toString();

    final type = PushNotificationType.fromString(typeString);

    if (sessionManager.currentUser == null) {
      log('🔔 Notification received but no user logged in',
          name: 'NOTIFICATION_SERVICE');
      return;
    }

    if (type != null) {
      if (PaiementStatusPage.isActive ||
          AppRouter.router.currentLocation.contains(PaiementStatusPage.name)) {
        log('🔔 Notification $type ignorée : flow de paiement déjà actif',
            name: 'NOTIFICATION_SERVICE');
        return;
      }

      const reverseSearchTypes = {
        PushNotificationType.reverseSearchPropositionDisponible,
        PushNotificationType.reverseSearchExpiree,
        PushNotificationType.reverseSearchSelectionExpiree,
        PushNotificationType.reverseSearchExpirationImminente,
      };

      if (reverseSearchTypes.contains(type)) {
        if (id != null && id.isNotEmpty) {
          unawaited(_openReverseSearchFromNotification(id));
        }
        return;
      }

      final code = data['code']?.toString();
      final referenceId = data['referenceId']?.toString();
      final route = type.getRoute(id, code: code, referenceId: referenceId);

      if (route != null) {
        log('🔔 Navigation: ${AppRouter.router.currentLocation} → $route',
            name: 'NOTIFICATION_SERVICE');
        AppRouter.router.pushIfDifferent(route);
      } else {
        log('⚠️ Pas de route pour type: $typeString',
            name: 'NOTIFICATION_SERVICE');
      }
    }
  }

  /// Ouvre la recherche inversée sur sa carte de résultats depuis une notification
  Future<void> _openReverseSearchFromNotification(String searchId) async {
    try {
      final item =
          await getIt<ReverseSearchRepository>().getReverseSearchById(searchId);
      final context = NavigationService.navigatorKey.currentContext;
      if (item == null || context == null || !context.mounted) {
        log('⚠️ Recherche $searchId introuvable ou contexte indisponible',
            name: 'NOTIFICATION_SERVICE');
        return;
      }
      ReverseSearchNavigation.resume(context, item);
    } catch (e) {
      log('⚠️ Erreur ouverture recherche inversée depuis notification: $e',
          name: 'NOTIFICATION_SERVICE');
    }
  }

  /// Enregistre / actualise l'appareil auprès du backend (`PUT /me/push-installations/:id`)
  Future<void> suscribeCurrentUser({String? token}) async {
    try {
      final user = sessionManager.currentUser;
      if (user == null ||
          user.accessToken == null ||
          user.accessToken!.isEmpty) {
        log('🔔 Push registration skipped: no user or access token',
            name: 'NOTIFICATION_SERVICE');
        return;
      }

      final pushToken = token ?? await pushProvider.getToken();
      if (pushToken == null || pushToken.isEmpty) {
        log('⚠️ Push token is null or empty', name: 'NOTIFICATION_SERVICE');
        return;
      }

      final installationId = await getPushInstallationId();
      final appVersion = await AppVersionService.getFullVersion();
      final platform = PushPlatform.current.value;
      final locale = Platform.localeName.replaceAll('_', '-');

      final body = <String, dynamic>{
        'app': PushApp.client.value,
        'platform': platform,
        'token': pushToken,
        'appVersion': appVersion,
        'locale': locale,
      };

      log('Registering push installation: $installationId (platform: $platform, version: $appVersion)',
          name: 'NOTIFICATION_SERVICE');

      await notificationRepository.registerPushInstallation(
        installationId: installationId,
        body: body,
      );

      log('✅ Push installation successfully registered',
          name: 'NOTIFICATION_SERVICE');
    } catch (e) {
      log('⚠️ Error in suscribeCurrentUser: $e', name: 'NOTIFICATION_SERVICE');
    }
  }

  /// Détache l'appareil du compte lors de la déconnexion (`DELETE /me/push-installations/:id`)
  Future<void> unsubcribeCurrentUser() async {
    try {
      final user = sessionManager.currentUser;
      if (user != null &&
          user.accessToken != null &&
          user.accessToken!.isNotEmpty) {
        final installationId = await getPushInstallationId();
        log('Deleting push installation: $installationId',
            name: 'NOTIFICATION_SERVICE');
        await notificationRepository.deletePushInstallation(installationId);
      }
      try {
        await pushProvider.deleteToken();
        log('✅ Push token deleted', name: 'NOTIFICATION_SERVICE');
      } catch (e) {
        log('⚠️ Error deleting push token: $e', name: 'NOTIFICATION_SERVICE');
      }
    } catch (e) {
      log('⚠️ Error in unsubcribeCurrentUser: $e',
          name: 'NOTIFICATION_SERVICE');
    }
  }
}
