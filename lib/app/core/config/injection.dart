import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:immoplus/app/core/config/isar_config.dart';
import 'package:immoplus/app/core/network/utils/env_handler.dart';
import 'package:immoplus/app/core/services/notification_service.dart';
import 'package:immoplus/app/core/services/remote_config_service.dart';
import 'package:injectable/injectable.dart';
import 'package:immoplus/app/core/network/utils/easy_loading_handler.dart';
import 'package:immoplus/firebase_options.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // 1. Initialize env handler
  try {
    final envHandler = EnvHandler();
    await envHandler.init().timeout(const Duration(seconds: 5));
    print('✅ EnvHandler.init() done');
  } catch (e) {
    print('⚠️ EnvHandler.init() failed: $e');
    rethrow;
  }

  // 2. Initialize Isar
  try {
    final isarConfig = IsarConfig();
    await isarConfig.init().timeout(const Duration(seconds: 5));
    print('✅ IsarConfig.init() done');
  } catch (e) {
    print('⚠️ IsarConfig.init() failed: $e');
    rethrow;
  }

  // 3. Initialize Firebase BEFORE GetIt.init() — AnalyticsService depends on it
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 10));
    print('✅ Firebase.initializeApp() done');
  } catch (e) {
    print('⚠️ Firebase.initializeApp() failed: $e');
  }

  // 4. Now initialize GetIt (AnalyticsService will find Firebase available)
  try {
    getIt.init();
    print('✅ getIt.init() done');
  } catch (e) {
    print('⚠️ getIt.init() failed: $e');
    rethrow;
  }

  // 5. Initialize EasyLoading
  try {
    await getIt<EasyLoadingHandler>().init().timeout(const Duration(seconds: 5));
    print('✅ EasyLoadingHandler.init() done');
  } catch (e) {
    print('⚠️ EasyLoadingHandler.init() failed: $e');
  }

  // 6. Initialize OneSignal in background (after Firebase)
  Future(() async {
    try {
      await getIt<NotificationService>().initConfig().timeout(const Duration(seconds: 10));
      print('✅ NotificationService.setupNotificationListener() done');
      getIt<NotificationService>().setupNotificationListener();
    } catch (e) {
      print('⚠️ NotificationService initialization failed: $e');
    }
  });

  // 7. Initialize RemoteConfig in background
  Future(() async {
    try {
      await getIt<RemoteConfigService>().initialize().timeout(const Duration(seconds: 10));
      print('✅ RemoteConfigService.initialize() done');
    } catch (e) {
      print('⚠️ RemoteConfigService.initialize() failed: $e');
    }
  });
}
