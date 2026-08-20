import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/appli/my_app.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:talker/talker.dart';

final talker = Talker();

class _DeepLinkEater extends WidgetsBindingObserver {
  @override
  Future<bool> didPushRouteInformation(
      RouteInformation routeInformation) async {
    final uri = routeInformation.uri;
    if (uri.toString().contains('/payment/hotel_reservations/')) {
      return true; // Empêche GoRouter de traiter cette route
    }
    return false;
  }

  @override
  Future<bool> didPushRoute(String route) async {
    if (route.contains('/payment/hotel_reservations/')) {
      return true;
    }
    return false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  OneSignal.initialize("3dcf3bc5-e4c7-4328-9d30-0f33cdedb1f0");
  return runApp(const MyApp());
}
