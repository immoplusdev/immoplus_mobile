// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/notification_service.dart';
import 'package:immoplus/app/data/models/remote/configs/config_model.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';
import 'package:immoplus/app/features/authentification/loading_page.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/services/connectivity_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static String name = 'splash';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final sessionManager = getIt<SessionManager>();
  final notificationService = getIt<NotificationService>();
  final dio = getIt<Dio>();

  Future<void> _getData({required BuildContext context}) async {
    ConfigModel configModel = await AuthRepository().getConfig();
    sessionManager.configModel = configModel;
    await sessionManager.getCurrentUser();

    if (sessionManager.currentUser == null) {
      AppRouter.router.goNamed(HomePage.name);
    } else {
      dio.options.headers['Authorization'] =
          'Bearer ${sessionManager.currentUser!.accessToken}';
      notificationService.suscribeCurrentUser();
      AppRouter.router.goNamed(HomePage.name);
    }
    // if (sessionManager.currentUser != null) {
    //   print(sessionManager.currentUser!.userId);
    //   OneSignal.login(sessionManager.currentUser!.userId ?? '');
    // }
    // try {
    //   await sessionManager.getCurrentUser();
    //   final info = await sessionManager.getOpenedInfo();
    //   if (info == null) {
    //     AppRouter.router.goNamed(OnboardingNewPage.name);
    //   } else {
    //     DioClient.token = sessionManager.currentUser!.accessToken;
    //     DioClient().dio.options.headers['Authorization'] =
    //         'Bearer ${sessionManager.currentUser!.accessToken}';

    //     AppRouter.router.goNamed(HomePage.name);
    //   }
    // } catch (e) {
    //   if (kDebugMode) {
    //     log(e.toString());
    //   }
    //   AppRouter.router.goNamed(HomePage.name);
    // }
  }

  @override
  void initState() {
    ConnectinityService.listen();

    _getData(context: context);

    // FireBaseServices(context).initNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingPage();
  }
}
