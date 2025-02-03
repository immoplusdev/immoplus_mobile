// import 'dart:developer';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:immoplus/app/routes/app_router.dart';
// import 'package:immoplus/app/utils/app_colors.dart';
// import 'package:permission_handler/permission_handler.dart';

// class FireBaseServices {
//   BuildContext context;
//   FireBaseServices(this.context);
//   static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   static Future<void> requestNotificationPermission(
//       BuildContext context) async {
//     // Request notification permission
//     PermissionStatus permissionStatus = await Permission.notification.request();

//     // Check the permission status
//     if (permissionStatus.isGranted) {
//       // Permission granted, handle accordingly
//       print("Notification permission granted");
//     } else {
//       // Permission not granted, handle accordingly
//       print("Notification permission not granted");

//       if (permissionStatus.isDenied) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text("Autorisation définitivement refusée"),
//               content: const Text(
//                   "L'autorisation de notification est définitivement refusée. Veuillez accorder l'autorisation dans les paramètres de l'application pour utiliser cette fonctionnalité."),
//               actions: <Widget>[
//                 TextButton(
//                   child: Text("Open Settings"),
//                   onPressed: () {
//                     openAppSettings();
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 TextButton(
//                   child: Text("Close"),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     }
//   }

//   static loginSubscriptions({required String userId}) async {
//     FirebaseMessaging.instance.subscribeToTopic('user_$userId');
//   }

//   initNotification() async {
//     NotificationSettings settings =
//         await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     await FirebaseMessaging.instance.subscribeToTopic('users');
//     await FirebaseMessaging.instance.subscribeToTopic('customers');
//     FirebaseMessaging.instance.getToken().then((String? token) {
//       assert(token != null);
//       //log(token!,name: 'Device Token');
//       // Now you can use the device token as needed
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       print("OUt APP");
//       print(message.data.toString());
//       print(message.data['path']);
//       if (message.data['path'] != null) {
//         //GoRouter.of(context).go(message.data['path']);
//         AppRouter.router.pushReplacement(message.data['path']);
//         //context.pushReplacement(message.data['path']);
//       }
//     });
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings(
//             'launcher_icon'); // Nom de l'icône sans extension

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       await InAppNotifications.show(
//           title: message.notification!.title,
//           leading: Icon(
//             FontAwesomeIcons.bell,
//             color: AppColors.primary,
//             // size: 50,
//           ),
//           // ending: Icon(
//           //   Icons.arrow_right_alt,
//           //   color: Colors.red,
//           // ),
//           description: message.notification!.body,
//           onTap: () {
//             // Do whatever you need!
//           });

//       context.read<NotificationCubit>().onGetData(
//             context: context,
//           );
//       if (message.data['type'] != null) {
//         if (message.data['type'] == 'payment') {
//           if (message.data['product_type'] != null &&
//               message.data['item_id'] != null) {
//             log("OKOK");
//             context.read<PaymentCubit>().getPaymentDetails(
//                 context: context,
//                 productType: message.data['product_type'],
//                 itemId: message.data['item_id']);
//             context
//                 .read<HistoryCubit>()
//                 .onGetDataId(context: context, id: message.data['item_id']);
//           }
//         }
//       }

//       if (message.data['isImage'] != null) {
//         print('isImage');
//         if (message.data['imageUrl'] != null) {
//           if (message.data['imageUrl'] == 'on') {
//             print('imageUrl');
//             FirebaseUtils.showImageNotification(
//                 context: context,
//                 imageUrl: message.data['imageUrl'],
//                 route: message.data['path']);
//           }
//         }
//       }
//     });
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
// }
