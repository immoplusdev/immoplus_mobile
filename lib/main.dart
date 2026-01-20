import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/appli/my_app.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  OneSignal.initialize("3dcf3bc5-e4c7-4328-9d30-0f33cdedb1f0");
  return runApp(const MyApp());
}
