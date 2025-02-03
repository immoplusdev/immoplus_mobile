import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void messageLog({required BuildContext context, required String message}) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(message),
        actions: [
          CupertinoDialogAction(
              child: Text(
                "OK",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          /*CupertinoDialogAction(
            child: Text("NO"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )*/
        ],
      );
    },
  );
}
