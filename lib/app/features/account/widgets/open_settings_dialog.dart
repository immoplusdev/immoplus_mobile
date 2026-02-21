import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

/// Affiche une boîte de dialogue proposant d'ouvrir les paramètres système.
void showOpenSettingsDialog(BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext ctx) => CupertinoAlertDialog(
      title: const Text('Voulez-vous ouvrir les paramètres ?'),
      content: const Text(
        'Pour voir les permissions veuillez ouvrir les paramètres',
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: false,
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Retour'),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(ctx).pop();
            openAppSettings();
          },
          child: const Text('Paramètre'),
        ),
      ],
    ),
  );
}
