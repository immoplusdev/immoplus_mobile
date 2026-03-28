import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/appli/my_app.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:talker/talker.dart';

final talker = Talker();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
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
