import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/main.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionPage extends StatefulWidget {
  static const name = 'permission_page';
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  openSeeting({required String title}) {
    showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Permission non accordée'),
        content: Text(title),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDestructiveAction: true,
            isDefaultAction: false,
            onPressed: () {
              context.pop();
            },
            child: const Text('OK'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDefaultAction: true,
            onPressed: () {
              context.pop();
              openAppSettings();
            },
            child: const Text('Paramètre'),
          ),
        ],
      ),
    );
  }

  PermissionStatus? notifPermission;
  PermissionStatus? locationPermission;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Permission.notification.status.then(
      (value) => setState(() {
        notifPermission = value;
      }),
    );

    Permission.location.status.then(
      (value) => setState(() {
        locationPermission = value;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permissions'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
                leading: Icon(CupertinoIcons.location),
                title: Text('Localisation'),
                trailing: CupertinoSwitch(
                  value: (locationPermission != null)
                      ? locationPermission!.isGranted
                      : false,
                  onChanged: (value) async {
                    openSeeting(
                        title:
                            "Ouvrire la paramettre de l'applicaiton et activer les permission de localisation");
                    if (locationPermission != null) {
                      if (!locationPermission!.isGranted) {
                        // Demander la permission si elle n'est pas accordée
                        await Permission.notification.request();
                      }
                      // Vous pouvez également ouvrir les paramètres de l'application si la permission est définitivement refusée
                      if (locationPermission!.isPermanentlyDenied) {}
                    }
                  },
                )),
            ListTile(
                leading: Icon(CupertinoIcons.bell),
                title: Text('Notifications'),
                trailing: CupertinoSwitch(
                  value: (notifPermission != null)
                      ? notifPermission!.isGranted
                      : false,
                  onChanged: (value) async {
                    openSeeting(
                        title:
                            "Ouvrire la paramettre de l'applicaiton et activer les permission de notification");

                    if (notifPermission != null) {
                      if (!notifPermission!.isGranted) {
                        // Demander la permission si elle n'est pas accordée
                        await Permission.notification.request();
                      }
                      // Vous pouvez également ouvrir les paramètres de l'application si la permission est définitivement refusée
                      if (notifPermission!.isPermanentlyDenied) {
                        openAppSettings();
                      }
                    }
                  },
                )),
            ListTile(
                leading: Icon(CupertinoIcons.bell_circle_fill),
                title: Text('Notifications teste'),
                trailing: CupertinoSwitch(
                  value: true,
                  onChanged: (value) {},
                )),
          ],
        ),
      )),
    );
  }
}
