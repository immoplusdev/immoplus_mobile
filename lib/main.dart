import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/appli/my_app.dart';
import 'package:immoplus/app/configs/app_typography.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:talker/talker.dart';

final talker = Talker();

class _DeepLinkEater extends WidgetsBindingObserver {
  @override
  Future<bool> didPushRouteInformation(
      RouteInformation routeInformation) async {
    final uri = routeInformation.uri.toString();
    if (uri.contains('/payment/')) {
      return true; // Empêche GoRouter de traiter cette route
    }
    return false;
  }

  @override
  Future<bool> didPushRoute(String route) async {
    if (route.contains('/payment/')) {
      return true;
    }
    return false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Gestionnaire global d'erreurs Flutter (layout, rendering, widgets)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    talker.handle(details.exception, details.stack);
  };

  // Gestionnaire global d'erreurs asynchrones non interceptées (Dart engine)
  PlatformDispatcher.instance.onError = (error, stack) {
    talker.handle(error, stack);
    return true;
  };

  // Vue de repli élégante pour éviter l'écran rouge de crash en production
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: AppColors.scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.redAccent,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                "Une erreur inattendue est survenue",
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                "Veuillez rafraîchir l'écran ou réessayer ultérieurement.",
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  };

  WidgetsBinding.instance.addObserver(_DeepLinkEater());
  // dotenv est chargé dans configureDependencies() → Stripe s'init après
  await configureDependencies();
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  await Stripe.instance.applySettings();
  await GoogleFonts.pendingFonts([
    GoogleFonts.plusJakartaSans(),
  ]);
  GoRouter.optionURLReflectsImperativeAPIs = true;
  OneSignal.initialize("3dcf3bc5-e4c7-4328-9d30-0f33cdedb1f0");
  return runApp(const MyApp());
}

