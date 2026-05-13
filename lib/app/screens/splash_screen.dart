import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart'; // ← AJOUTER
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/notification_service.dart';
import 'package:immoplus/app/data/models/remote/configs/config_model.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';
import 'package:immoplus/app/features/authentification/loading_page.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/onboarding/onboarding_new_page.dart';
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
    // ✅ Initialiser les services (toujours nécessaire)
    ConfigModel configModel = await AuthRepository().getConfig();
    sessionManager.configModel = configModel;
    await sessionManager.getCurrentUser();

    // ✅ Configurer l'authentification si nécessaire
    if (sessionManager.currentUser != null) {
      notificationService.suscribeCurrentUser();
    }

    // Vérification de l'onboarding
    final hasSeenOnboarding = await sessionManager.hasReadOnboarding();

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    // ✅ VÉRIFIER LA ROUTE ACTUELLE AVANT DE NAVIGUER
    final currentPath = GoRouterState.of(context).uri.path;

    // Si on n'est plus sur "/", c'est qu'un deep link a pris le contrôle
    if (currentPath != '/') {
      print('✅ Deep link detected ($currentPath), skipping splash navigation');
      return; // ← NE PAS NAVIGUER
    }

    // ✅ Sinon, flow normal
    if (!hasSeenOnboarding) {
      AppRouter.router.goNamed(OnboardingNewPage.name);
      return;
    }

    AppRouter.router.goNamed(HomePage.name);
  }

  @override
  void initState() {
    super.initState();
    ConnectinityService.listen();

    // ✅ Attendre que le widget tree soit construit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingPage();
  }
}
