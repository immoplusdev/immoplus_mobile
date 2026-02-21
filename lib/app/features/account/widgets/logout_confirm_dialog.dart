import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Affiche une boîte de dialogue de confirmation de déconnexion.
/// [onLogout] est appelé lorsque l'utilisateur confirme (ex: sessionManager.logout()).
void showLogoutConfirmDialog(
  BuildContext context, {
  required Future<void> Function() onLogout,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return CupertinoAlertDialog(
        title: const SizedBox(
          child: Center(
            child: Icon(
              Icons.exit_to_app_rounded,
              size: 60,
              color: Colors.red,
            ),
          ),
        ),
        content: const Text('Souhaitez vous vous déconnecter ?'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Annuler',
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          TextButton(
            child: const Text(
              'Se déconnecter',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await onLogout();
            },
          ),
        ],
      );
    },
  );
}
