import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/firebase_options.dart';
import 'package:injectable/injectable.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

@lazySingleton
class NotificationService {
  SessionManager sessionManager;
  NotificationService(this.sessionManager);

  initConfig() async {
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    //Remove this method to stop OneSignal Debugging
    if (kDebugMode) {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    }
    OneSignal.initialize(dotenv.env['ONE_SIGNAL_KEY'] ?? '');
    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);
  }

  suscribeCurrentUser() async {
    try {
      if (sessionManager.currentUser != null) {
        await OneSignal.login(sessionManager.currentUser!.userId ?? '');

        if (kDebugMode) {
          log(sessionManager.currentUser!.userId.toString(),
              name: 'SUSCRIPTION SUCCESS');
        }
      } else {
        log('SUBSCRIPTION FAILD NO USER');
      }
    } catch (e) {
      log('SUBSCRIPTION  ${e.toString()}');
    }
  }
}
