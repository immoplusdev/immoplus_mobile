import 'package:get_it/get_it.dart';
import 'package:immoplus/app/core/config/isar_config.dart';
import 'package:immoplus/app/core/network/utils/env_handler.dart';
import 'package:immoplus/app/core/services/notification_service.dart';
import 'package:immoplus/app/core/services/remote_config_service.dart';
import 'package:injectable/injectable.dart';
import 'package:immoplus/app/core/network/utils/easy_loading_handler.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  getIt.init();
  await getIt<EnvHandler>().init();
  await getIt<IsarConfig>().init();
  await getIt<NotificationService>().initConfig();
  await getIt<EasyLoadingHandler>().init();
  await getIt<RemoteConfigService>().initialize();
}
