import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:immoplus/app/core/config/isar_config.dart';
import 'package:immoplus/app/core/network/utils/env_handler.dart';
import 'package:immoplus/app/core/services/notification_service.dart';
import 'package:immoplus/app/core/services/remote_config_service.dart';
import 'package:immoplus/main.dart';
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
    talker.info('EnvHandler.init() done');
  } catch (e, stack) {
    talker.error('EnvHandler.init() failed: $e', e, stack);
    rethrow;
  }

  // 2. Initialize Isar
  try {
    final isarConfig = IsarConfig();
    await isarConfig.init().timeout(const Duration(seconds: 5));
    talker.info('IsarConfig.init() done');
  } catch (e, stack) {
    talker.error('IsarConfig.init() failed: $e', e, stack);
    rethrow;
  }

  // 3. Initialize Firebase BEFORE GetIt.init() — AnalyticsService depends on it
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 10));
    talker.info('Firebase.initializeApp() done');
  } catch (e, stack) {
    talker.error('Firebase.initializeApp() failed: $e', e, stack);
  }

  // 4. Now initialize GetIt (AnalyticsService will find Firebase available)
  try {
    getIt.init();
    talker.info('getIt.init() done');
  } catch (e, stack) {
    talker.error('getIt.init() failed: $e', e, stack);
    rethrow;
  }

  // 5. Initialize EasyLoading
  try {
    await getIt<EasyLoadingHandler>().init().timeout(const Duration(seconds: 5));
    talker.info('EasyLoadingHandler.init() done');
  } catch (e, stack) {
    talker.error('EasyLoadingHandler.init() failed: $e', e, stack);
  }

  // 6. Initialize OneSignal in background (after Firebase)
  Future(() async {
    try {
      await getIt<NotificationService>().initConfig().timeout(const Duration(seconds: 10));
      talker.info('NotificationService.setupNotificationListener() done');
      getIt<NotificationService>().setupNotificationListener();
    } catch (e, stack) {
      talker.error('NotificationService initialization failed: $e', e, stack);
    }
  });

  // 7. Initialize RemoteConfig in background
  Future(() async {
    try {
      await getIt<RemoteConfigService>().initialize().timeout(const Duration(seconds: 10));
      talker.info('RemoteConfigService.initialize() done');
    } catch (e, stack) {
      talker.error('RemoteConfigService.initialize() failed: $e', e, stack);
    }
  });
}
