import 'package:flutter/cupertino.dart';

/// Confirmation de blocage (spec §7.2), calquée sur
/// `delete_account_dialog.dart` : Cupertino, action destructive en rouge.
Future<void> showBlockConversationDialog(
  BuildContext context, {
  required String hostLabel,
  required Future<bool> Function() onConfirm,
}) {
  return showCupertinoDialog<void>(
    context: context,
    builder: (dialogContext) {
      bool isLoading = false;
      return StatefulBuilder(
        builder: (context, setState) {
          return CupertinoAlertDialog(
            title: Text('Bloquer $hostLabel ?'),
            content: const Text(
              'Vous ne pourrez plus envoyer ni recevoir de messages dans '
              'cette conversation.',
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: isLoading ? null : () => Navigator.of(dialogContext).pop(),
                child: const Text('Annuler'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() => isLoading = true);
                        await onConfirm();
                        if (dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      },
                child: isLoading
                    ? const CupertinoActivityIndicator()
                    : const Text('Bloquer'),
              ),
            ],
          );
        },
      );
    },
  );
}
