import 'package:permission_handler/permission_handler.dart';

class PermissionServices {
  static Future<void> requestNotificationPermissions() async {
    await Permission.notification.request();
    if (await Permission.notification.request().isGranted) {
      // Permission is granted.
      // You can now proceed with handling notifications.
    } else {
      /*showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Location Permission Denied'),
          content: Text(
              'Please grant location permission to access your current location.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text('Settings'),
              onPressed: () => openAppSettings(),
            ),
          ],
        ),
      );*/
    }
  }
}
