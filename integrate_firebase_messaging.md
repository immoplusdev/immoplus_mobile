# 🚀 Guide Complet d'Intégration Firebase Cloud Messaging (FCM) — Application Pro

Ce guide détaille **l'intégralité du processus d'architecture, d'implémentation et de configuration** pour migrer / intégrer les notifications Push via **Firebase Cloud Messaging (FCM)** sur l'application **ImmoPlus Pro**, en suivant les principes de **Clean Architecture** et les retours d'expérience iOS & Android.

---

## 📑 Table des Matières

1. [Architecture & Principes Clés](#1-architecture--principes-clés)
2. [Dépendances & Packages (`pubspec.yaml`)](#2-dépendances--packages-pubspecyaml)
3. [Modèles de Données & Énumérations](#3-modèles-de-données--énumérations)
4. [Couche Réseau & API Backend (`Retrofit`)](#4-couche-réseau--api-backend-retrofit)
5. [Implémentation des Services Core (Clean Architecture)](#5-implémentation-des-services-core-clean-architecture)
   - [5.1 Contrat Abstrait `PushProvider`](#51-contrat-abstrait-pushprovider)
   - [5.2 Modèle Agnostique `PushMessage`](#52-modèle-agnostique-pushmessage)
   - [5.3 Service d'Identifiant d'Installation `PushInstallationService`](#53-service-didentifiant-dinstallation-pushinstallationservice)
   - [5.4 Implémentation FCM `FirebasePushProvider`](#54-implémentation-fcm-firebasepushprovider)
   - [5.5 Orchestrateur Métier `NotificationService`](#55-orchestrateur-métier-notificationservice)
6. [Intégration avec la Session & Cycles de Vie (`main.dart` & `SessionManager`)](#6-intégration-avec-la-session--cycles-de-vie-maindart--sessionmanager)
7. [Configuration Plateforme Android](#7-configuration-plateforme-android)
8. [Configuration Plateforme iOS](#8-configuration-plateforme-ios)
9. [Fichiers de Test APNs & Procédure de Test Simulateur](#9-fichiers-de-test-apns--procédure-de-test-simulateur)
10. [Checklist Finale de Validation](#10-checklist-finale-de-validation)

---

## 1. Architecture & Principes Clés

```
┌─────────────────────────────────────────────────────────────┐
│                     NotificationService                     │
│  (Orchestrateur métier, routage, session, synchro backend)  │
└──────────────┬───────────────────────────────┬──────────────┘
               │                               │
               ▼                               ▼
     ┌───────────────────┐           ┌───────────────────┐
     │   PushProvider    │           │ PushInstallation  │
     │    (Interface)    │           │      Service      │
     └─────────┬─────────┘           └───────────────────┘
               │
               ▼
   ┌───────────────────────┐
   │ FirebasePushProvider  │
   │ (FCM + Notifications) │
   └───────────────────────┘
```

- **Découplage total (Inversion de dépendance)** : Le `NotificationService` ne dépend jamais directement du SDK Firebase, mais de l'interface abstraite `PushProvider`.
- **Remplacement aisé** : Changer de fournisseur Push (OneSignal, Pusher, etc.) nécessite uniquement de créer une nouvelle classe implémentant `PushProvider` sans modifier aucune ligne de logique métier.
- **Séparation des responsabilités (SRP)** : La gestion de l'identifiant matériel unique de l'appareil (UUID v4) est encapsulée dans `PushInstallationService`.

---

## 2. Dépendances & Packages (`pubspec.yaml`)

Dans `pubspec.yaml`, déclarez les packages avec des versions compatibles Swift 6 / Xcode 16 et Java desugaring :

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase Core & FCM
  firebase_core: ^4.3.0
  firebase_messaging: ^16.7.0
  firebase_analytics: ^12.6.0 # Version >= 12.6.0 requise pour éviter le conflit Swift 6 FlutterError
  firebase_remote_config: ^6.7.0 # Version >= 6.7.0 requise pour Swift 6

  # Notifications locales Android foreground
  flutter_local_notifications: ^22.3.1

  # Utilitaires système & Injection
  uuid: ^4.5.1
  shared_preferences: ^2.5.5
  package_info_plus: ^9.0.1
  injectable: ^2.7.1+4
  get_it: ^8.3.0
```

Exécutez ensuite :
```bash
flutter pub get
```

---

## 3. Modèles de Données & Énumérations

### 3.1 Énumérations Push (`lib/app/data/enums/account_source.dart`)

```dart
/// Type d'application cliente auprès du backend
enum PushApp {
  client('client'),
  pro('pro');

  final String value;
  const PushApp(this.value);
}

/// Plateforme de l'appareil
enum PushPlatform {
  android('android'),
  ios('ios');

  final String value;
  const PushPlatform(this.value);

  static PushPlatform get current =>
      Platform.isIOS ? PushPlatform.ios : PushPlatform.android;
}
```

### 3.2 Types de notifications Pro (`lib/app/core/enums/push_notification_type.dart`)

Assurez-vous de déclarer les types de notifications spécifiques à l'application **Pro** (ex : nouvelle réservation, validation de visite, message client, etc.) avec leur méthode `fromString` et `getRoute`.

---

## 4. Couche Réseau & API Backend (`Retrofit`)

### 4.1 Provider (`lib/app/data/providers/notification_provider.dart`)

```dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_provider.g.dart';

@RestApi()
abstract class NotificationProvider {
  factory NotificationProvider(Dio dio, {String baseUrl}) = _NotificationProvider;

  /// Enregistre ou actualise l'appareil auprès du backend
  @PUT('/me/push-installations/{installationId}')
  Future<HttpResponse<dynamic>> registerPushInstallation({
    @Path('installationId') required String installationId,
    @Body() required Map<String, dynamic> body,
  });

  /// Détache l'appareil du compte lors de la déconnexion
  @DELETE('/me/push-installations/{installationId}')
  Future<HttpResponse<dynamic>> deletePushInstallation({
    @Path('installationId') required String installationId,
  });
}
```

### 4.2 Repository (`lib/app/data/repositories/notification_repository.dart`)

```dart
import 'package:injectable/injectable.dart';
import 'package:immoplus_pro_mobile/app/data/providers/notification_provider.dart';

@lazySingleton
class NotificationRepository {
  final NotificationProvider _provider;

  NotificationRepository(this._provider);

  Future<void> registerPushInstallation({
    required String installationId,
    required Map<String, dynamic> body,
  }) async {
    await _provider.registerPushInstallation(
      installationId: installationId,
      body: body,
    );
  }

  Future<void> deletePushInstallation(String installationId) async {
    await _provider.deletePushInstallation(installationId: installationId);
  }
}
```

---

## 5. Implémentation des Services Core (Clean Architecture)

### 5.1 Modèle Agnostique `PushMessage` (`lib/app/core/services/push/push_message.dart`)

```dart
class PushMessage {
  final String? messageId;
  final String? title;
  final String? body;
  final Map<String, dynamic> data;

  const PushMessage({
    this.messageId,
    this.title,
    this.body,
    this.data = const {},
  });
}
```

### 5.2 Contrat Abstrait `PushProvider` (`lib/app/core/services/push/push_provider.dart`)

```dart
import 'package:immoplus_pro_mobile/app/core/services/push/push_message.dart';

abstract class PushProvider {
  Future<void> initialize();
  Future<bool> requestPermission();
  Future<String?> getToken();
  Future<void> deleteToken();

  Stream<String> get onTokenRefresh;
  Stream<PushMessage> get onForegroundMessage;
  Stream<PushMessage> get onNotificationOpenedApp;
  Future<PushMessage?> getInitialMessage();
}
```

### 5.3 Service d'Identifiant d'Installation `PushInstallationService` (`lib/app/core/services/push/push_installation_service.dart`)

```dart
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class PushInstallationService {
  static const String _pushInstallationIdKey = 'push_installation_id';
  String? _cachedInstallationId;

  Future<String> getInstallationId() async {
    if (_cachedInstallationId != null) return _cachedInstallationId!;
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_pushInstallationIdKey);
    if (id == null || id.isEmpty) {
      id = const Uuid().v4();
      await prefs.setString(_pushInstallationIdKey, id);
    }
    _cachedInstallationId = id;
    return id;
  }
}
```

### 5.4 Implémentation FCM `FirebasePushProvider` (`lib/app/core/services/push/firebase_push_provider.dart`)

```dart
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:immoplus_pro_mobile/app/core/services/push/push_message.dart';
import 'package:immoplus_pro_mobile/app/core/services/push/push_provider.dart';
import 'package:immoplus_pro_mobile/firebase_options.dart';
import 'package:injectable/injectable.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (_) {}
  log('Handling background message: ${message.messageId}', name: 'FCM_BG');
}

@LazySingleton(as: PushProvider)
class FirebasePushProvider implements PushProvider {
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'immoplus_pro_high_importance_channel',
    'Notifications ImmoPlus Pro',
    description: 'Canal pour les notifications push ImmoPlus Pro',
    importance: Importance.max,
    playSound: true,
  );

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final StreamController<PushMessage> _foregroundMessageController =
      StreamController<PushMessage>.broadcast();
  final StreamController<PushMessage> _notificationOpenedAppController =
      StreamController<PushMessage>.broadcast();

  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    } catch (_) {}

    // 1. Initialiser le plugin de notifications locales
    const androidInit = AndroidInitializationSettings('@drawable/ic_notification');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final data = jsonDecode(response.payload!) as Map<String, dynamic>;
            final message = PushMessage(
              messageId: data['id']?.toString(),
              title: data['title']?.toString(),
              body: data['body']?.toString(),
              data: data,
            );
            _notificationOpenedAppController.add(message);
          } catch (e) {
            log('Error parsing local notification payload: $e', name: 'FCM_PROVIDER');
          }
        }
      },
    );

    // 2. Créer le canal Android
    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(_androidChannel);
    }

    // 3. Demander la permission système
    await requestPermission();

    // 4. Configuration d'affichage Foreground sur iOS
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 5. Écouteurs des messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('🔔 FCM onMessage received: ${message.messageId}', name: 'FCM_PROVIDER');
      final pushMessage = _mapRemoteMessage(message);
      _foregroundMessageController.add(pushMessage);

      // Sur Android, afficher une bannière locale au premier plan
      if (Platform.isAndroid) {
        final title = message.notification?.title ?? message.data['title']?.toString();
        final body = message.notification?.body ?? message.data['body']?.toString();

        if (title != null || body != null) {
          final notifId = message.messageId != null
              ? message.messageId.hashCode
              : message.hashCode;
          _localNotifications.show(
            id: notifId,
            title: title,
            body: body,
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                _androidChannel.id,
                _androidChannel.name,
                channelDescription: _androidChannel.description,
                icon: '@drawable/ic_notification',
                importance: Importance.max,
                priority: Priority.high,
                color: const Color(0xFF2172CB),
              ),
            ),
            payload: jsonEncode(message.data),
          );
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('🔔 FCM onMessageOpenedApp received: ${message.messageId}', name: 'FCM_PROVIDER');
      _notificationOpenedAppController.add(_mapRemoteMessage(message));
    });

    _isInitialized = true;
    log('✅ FirebasePushProvider initialized', name: 'FCM_PROVIDER');
  }

  @override
  Future<bool> requestPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      log('Error requesting permission: $e', name: 'FCM_PROVIDER');
      return false;
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      // Sur iOS, attendre que le token APNs natif soit disponible
      if (Platform.isIOS) {
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        int retries = 0;
        while (apnsToken == null && retries < 5) {
          await Future.delayed(const Duration(milliseconds: 500));
          apnsToken = await FirebaseMessaging.instance.getAPNSToken();
          retries++;
        }
        log("APNs token: $apnsToken", name: 'FCM_PROVIDER');
      }
      final token = await FirebaseMessaging.instance.getToken();
      log("token FirebaseMessaging: $token", name: 'FCM_PROVIDER');
      return token;
    } catch (e) {
      log('Error getting FCM token: $e', name: 'FCM_PROVIDER');
      return null;
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      log('Error deleting FCM token: $e', name: 'FCM_PROVIDER');
    }
  }

  @override
  Stream<String> get onTokenRefresh => FirebaseMessaging.instance.onTokenRefresh;

  @override
  Stream<PushMessage> get onForegroundMessage => _foregroundMessageController.stream;

  @override
  Stream<PushMessage> get onNotificationOpenedApp => _notificationOpenedAppController.stream;

  @override
  Future<PushMessage?> getInitialMessage() async {
    try {
      final message = await FirebaseMessaging.instance.getInitialMessage();
      return message != null ? _mapRemoteMessage(message) : null;
    } catch (e) {
      log('Error getting initial message: $e', name: 'FCM_PROVIDER');
      return null;
    }
  }

  PushMessage _mapRemoteMessage(RemoteMessage message) {
    return PushMessage(
      messageId: message.messageId,
      title: message.notification?.title ?? message.data['title']?.toString(),
      body: message.notification?.body ?? message.data['body']?.toString(),
      data: Map<String, dynamic>.from(message.data),
    );
  }
}
```

### 5.5 Orchestrateur Métier `NotificationService` (`lib/app/core/services/notification_service.dart`)

```dart
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:immoplus_pro_mobile/app/core/enums/push_notification_type.dart';
import 'package:immoplus_pro_mobile/app/core/network/utils/session_manager.dart';
import 'package:immoplus_pro_mobile/app/core/services/analytics_service.dart';
import 'package:immoplus_pro_mobile/app/core/services/app_version_service.dart';
import 'package:immoplus_pro_mobile/app/core/services/push/push_installation_service.dart';
import 'package:immoplus_pro_mobile/app/core/services/push/push_message.dart';
import 'package:immoplus_pro_mobile/app/core/services/push/push_provider.dart';
import 'package:immoplus_pro_mobile/app/data/enums/account_source.dart';
import 'package:immoplus_pro_mobile/app/data/repositories/notification_repository.dart';
import 'package:immoplus_pro_mobile/app/routes/app_router.dart';

@lazySingleton
class NotificationService {
  final PushProvider pushProvider;
  final SessionManager sessionManager;
  final NotificationRepository notificationRepository;
  final AnalyticsService analyticsService;
  final PushInstallationService pushInstallationService;

  bool _listenersConfigured = false;

  NotificationService(
    this.pushProvider,
    this.sessionManager,
    this.notificationRepository,
    this.analyticsService,
    this.pushInstallationService,
  );

  Future<String> getPushInstallationId() =>
      pushInstallationService.getInstallationId();

  /// Initialise la configuration et l'écoute du renouvellement de token
  Future<void> initConfig() async {
    await pushProvider.initialize();

    pushProvider.onTokenRefresh.listen((token) {
      log('🔔 Push token refreshed: $token', name: 'NOTIFICATION_SERVICE');
      suscribeCurrentUser(token: token);
    });

    await suscribeCurrentUser();
  }

  /// Configure les listeners globaux (Foreground, Background, Terminated)
  void setupNotificationListener() {
    if (_listenersConfigured) {
      log('🔔 Listeners already configured, skipping duplicate', name: 'NOTIFICATION_SERVICE');
      return;
    }
    _listenersConfigured = true;

    // 1. Premier plan
    pushProvider.onForegroundMessage.listen((PushMessage message) {
      final typeString = message.data['type']?.toString();
      log('🔔 Push received in foreground: ${message.messageId}, type: $typeString',
          name: 'NOTIFICATION_SERVICE');
      analyticsService.logNotificationReceived(
        notificationType: typeString ?? 'unknown',
        notificationId: message.messageId,
      );
    });

    // 2. Clic depuis l'arrière-plan
    pushProvider.onNotificationOpenedApp.listen((PushMessage message) {
      log('🔔 Push clicked from background: ${message.messageId}', name: 'NOTIFICATION_SERVICE');
      analyticsService.logNotificationTapped(
        notificationType: message.data['type']?.toString() ?? 'unknown',
        notificationId: message.messageId,
      );
      handleNotificationData(message.data);
    });

    // 3. Clic à froid (Terminated)
    pushProvider.getInitialMessage().then((PushMessage? message) {
      if (message != null) {
        log('🔔 Initial push from terminated state: ${message.messageId}',
            name: 'NOTIFICATION_SERVICE');
        analyticsService.logNotificationTapped(
          notificationType: message.data['type']?.toString() ?? 'unknown',
          notificationId: message.messageId,
        );
        handleNotificationData(message.data);
      }
    });
  }

  /// Routage après clic sur notification
  void handleNotificationData(Map<String, dynamic> data) {
    log("handleNotificationData: $data", name: 'NOTIFICATION_SERVICE');
    final typeString = data['type']?.toString();
    final id = data['id']?.toString() ??
        data['alertId']?.toString() ??
        data['reservationId']?.toString() ??
        data['conversationId']?.toString();

    final type = PushNotificationType.fromString(typeString);

    if (sessionManager.currentUser == null) {
      log('🔔 Notification received but no user logged in', name: 'NOTIFICATION_SERVICE');
      return;
    }

    if (type != null) {
      final code = data['code']?.toString();
      final referenceId = data['referenceId']?.toString();
      final route = type.getRoute(id, code: code, referenceId: referenceId);

      if (route != null) {
        log('🔔 Navigation: ${AppRouter.router.currentLocation} → $route',
            name: 'NOTIFICATION_SERVICE');
        AppRouter.router.pushIfDifferent(route);
      }
    }
  }

  /// Enregistre l'appareil auprès du backend (`PUT /me/push-installations/:id`)
  Future<void> suscribeCurrentUser({String? token}) async {
    try {
      final user = sessionManager.currentUser;
      if (user == null || user.accessToken == null || user.accessToken!.isEmpty) {
        log('🔔 Push registration skipped: no authenticated user', name: 'NOTIFICATION_SERVICE');
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
        'app': PushApp.pro.value, // 'pro'
        'platform': platform,
        'token': pushToken,
        'appVersion': appVersion,
        'locale': locale,
      };

      log('Registering push installation: $installationId (platform: $platform, app: pro)',
          name: 'NOTIFICATION_SERVICE');

      await notificationRepository.registerPushInstallation(
        installationId: installationId,
        body: body,
      );

      log('✅ Push installation successfully registered', name: 'NOTIFICATION_SERVICE');
    } catch (e) {
      log('⚠️ Error in suscribeCurrentUser: $e', name: 'NOTIFICATION_SERVICE');
    }
  }

  /// Détache l'appareil du compte lors de la déconnexion (`DELETE /me/push-installations/:id`)
  Future<void> unsubcribeCurrentUser() async {
    try {
      final user = sessionManager.currentUser;
      if (user != null && user.accessToken != null && user.accessToken!.isNotEmpty) {
        final installationId = await getPushInstallationId();
        log('Deleting push installation: $installationId', name: 'NOTIFICATION_SERVICE');
        await notificationRepository.deletePushInstallation(installationId);
      }
      try {
        await pushProvider.deleteToken();
        log('✅ Push token deleted', name: 'NOTIFICATION_SERVICE');
      } catch (e) {
        log('⚠️ Error deleting push token: $e', name: 'NOTIFICATION_SERVICE');
      }
    } catch (e) {
      log('⚠️ Error in unsubcribeCurrentUser: $e', name: 'NOTIFICATION_SERVICE');
    }
  }
}
```

---

## 6. Intégration avec la Session & Cycles de Vie (`main.dart` & `SessionManager`)

### 6.1 `lib/main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enregistrer le background handler FCM au point d'entrée
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await configureDependencies();
  runApp(const MyApp());
}
```

### 6.2 `lib/app/core/config/injection.dart`

```dart
Future<void> configureDependencies() async {
  // 1. Initialiser Firebase
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print('⚠️ Firebase.initializeApp() error: $e');
  }

  // 2. Initialiser GetIt
  getIt.init();

  // 3. Initialiser NotificationService en arrière-plan
  Future(() async {
    try {
      await getIt<NotificationService>().initConfig().timeout(const Duration(seconds: 10));
      getIt<NotificationService>().setupNotificationListener();
    } catch (e) {
      print('⚠️ NotificationService init failed: $e');
    }
  });
}
```

### 6.3 `lib/app/core/network/utils/session_manager.dart`

```dart
Future<void> saveUser(UserModelSchema user) async {
  // ... sauvegarde locale ...
  currentUser = user;
  
  // Enregistrement de l'appareil FCM dès la connexion
  getIt<NotificationService>().suscribeCurrentUser();
}

Future<void> logout() async {
  getIt<AnalyticsService>().clearUserIdentity();

  // ⚠️ CRITIQUE : Désabonner du backend AVANT de vider le token de session
  try {
    await getIt<NotificationService>().unsubcribeCurrentUser();
  } catch (e) {
    print('Error unsubscribing push: $e');
  }

  await clearSession();
  AppRouter.router.go('/');
}
```

### 6.4 `lib/app/extensions/go_router_extensions.dart` (Correction du Bug de Racine `'/'`)

```dart
extension GoRouterExtension on GoRouter {
  String get currentLocation => routeInformationProvider.value.uri.path;

  void pushIfDifferent(String route) {
    final targetPath = Uri.tryParse(route)?.path ?? route;
    if (currentLocation != targetPath) {
      push(route);
    }
  }
}
```

---

## 7. Configuration Plateforme Android

### 7.1 `android/app/build.gradle`

Activez le Desugaring Java 8+ (requis par `flutter_local_notifications`) :

```groovy
android {
    defaultConfig {
        // ...
        multiDexEnabled true
    }

    compileOptions {
        coreLibraryDesugaringEnabled true
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
}

dependencies {
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'
}
```

Appliquez le plugin Google Services tout en bas :
```groovy
apply plugin: 'com.google.gms.google-services'
```

### 7.2 `android/app/src/main/AndroidManifest.xml`

```xml
<application ...>
    <!-- Métadonnées de notification FCM par défaut -->
    <meta-data
        android:name="com.google.firebase.messaging.default_notification_icon"
        android:resource="@drawable/ic_notification" />
    <meta-data
        android:name="com.google.firebase.messaging.default_notification_color"
        android:resource="@color/notification_color" />
    <meta-data
        android:name="com.google.firebase.messaging.default_notification_channel_id"
        android:value="immoplus_pro_high_importance_channel" />
</application>
```

### 7.3 Couleurs & Icônes

- Dans `android/app/src/main/res/values/colors.xml` :
  ```xml
  <resources>
      <color name="notification_color">#2172CB</color>
  </resources>
  ```
- Placez une icône silhouette blanche avec fond transparent (`ic_notification.png`) dans :
  - `res/drawable/ic_notification.png`
  - `res/drawable-mdpi/ic_notification.png`
  - `res/drawable-hdpi/ic_notification.png`
  - `res/drawable-xhdpi/ic_notification.png`
  - `res/drawable-xxhdpi/ic_notification.png`
  - `res/drawable-xxxhdpi/ic_notification.png`

---

## 8. Configuration Plateforme iOS

### 8.1 Fichier Firebase & Capacités
1. Téléchargez et placez `GoogleService-Info.plist` (du projet Firebase Pro) dans `ios/Runner/GoogleService-Info.plist`.
2. Dans `ios/Runner/Info.plist` :
   ```xml
   <key>UIBackgroundModes</key>
   <array>
       <string>fetch</string>
       <string>remote-notification</string>
   </array>
   ```
3. Dans `ios/Runner/Runner.entitlements` :
   ```xml
   <dict>
       <key>aps-environment</key>
       <string>development</string>
   </dict>
   ```

### 8.2 Nettoyage OneSignal dans `ios/Podfile`
Retirez la cible d'extension OneSignal du `ios/Podfile` :
```ruby
# ❌ Supprimer ou commenter :
# target 'OneSignalNotificationServiceExtension' do
#   pod 'OneSignalXCFramework', '>= 5.0.0', '< 6.0'
# end
```

Exécutez dans le terminal :
```bash
cd ios
pod update
```

---

## 9. Fichiers de Test APNs & Procédure de Test Simulateur

### 9.1 Structure obligatoire d'un fichier `.apns` FCM pour iOS Simulateur

> ⚠️ **IMPORTANT :** Le SDK Firebase iOS exige la clé `"gcm.message_id"` pour identifier et rediriger le clic vers Flutter.

Créez le dossier `notification_tests/` à la racine du projet avec vos fichiers de test :

#### `notification_tests/test_pro_reservation.apns`
```json
{
  "Simulator Target Bundle": "com.immoplus.pro",
  "aps": {
    "alert": {
      "title": "Nouvelle Réservation !",
      "body": "Un client vient d'effectuer une demande de réservation."
    },
    "sound": "default",
    "badge": 1,
    "mutable-content": 1
  },
  "gcm.message_id": "1234567890",
  "type": "new_reservation_waiting",
  "reservationId": "d001ed2f-85f4-4447-98e7-3d99181e4e09",
  "id": "d001ed2f-85f4-4447-98e7-3d99181e4e09"
}
```

### 9.2 Comment Tester sur Simulateur iOS

1. Lancez l'application Pro sur le simulateur :
   ```bash
   flutter run
   ```
2. Connectez-vous avec un compte Pro.
3. Mettez l'application en arrière-plan (`Cmd + Shift + H`).
4. Envoyez le push :
   ```bash
   xcrun simctl push booted com.immoplus.pro notification_tests/test_pro_reservation.apns
   ```
5. Cliquez sur la bannière de notification : l'application s'ouvre et navigue automatiquement vers la réservation concernée.

---

## 10. Checklist Finale de Validation

- [ ] `build_runner` s'est exécuté sans conflit (`dart run build_runner build --delete-conflicting-outputs`).
- [ ] `flutter analyze` ne remonte aucune erreur.
- [ ] Le payload envoyé à `PUT /me/push-installations/:id` contient `'app': 'pro'`.
- [ ] L'icône de notification Android s'affiche en blanc net sans carré gris.
- [ ] À la déconnexion, `DELETE /me/push-installations/:id` est bien exécuté avant de vider la session.
- [ ] Le build iOS (`xcodebuild`) compile avec succès (`Code 0`).
