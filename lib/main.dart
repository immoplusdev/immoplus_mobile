import 'package:adaptive_liquid_bottom_nav_bar/adaptive_liquid_bottom_nav_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/appli/my_app.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/services/push/firebase_push_provider.dart';
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
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await AdaptiveLiquidBottomNavigationBar.precacheIOSVersion();
  WidgetsBinding.instance.addObserver(_DeepLinkEater());
  // dotenv est chargé dans configureDependencies() → Stripe s'init après
  await configureDependencies();
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  await Stripe.instance.applySettings();
  await GoogleFonts.pendingFonts([
    GoogleFonts.sen(),
    GoogleFonts.inter(),
    GoogleFonts.plusJakartaSans(),
    GoogleFonts.inder(),
    GoogleFonts.dmSans(),
  ]);
  GoRouter.optionURLReflectsImperativeAPIs = true;
  return runApp(const MyApp());
}

