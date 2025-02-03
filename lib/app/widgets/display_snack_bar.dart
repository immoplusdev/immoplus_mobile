import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

displaySnackBar(
    {required BuildContext context,
    required bool warning,
    required String title,
    bool removeUntil = true}) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(
        duration: Duration(
          seconds: 2,
        ),
        backgroundColor:
            warning ? Colors.redAccent : Color.fromARGB(255, 104, 209, 151),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 100),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                warning
                    ? CupertinoIcons.exclamationmark_circle_fill
                    : CupertinoIcons.check_mark_circled_solid,
                size: 30,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        /*action: SnackBarAction(
      label: 'ok',
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),*/
      ))
      .closed
      .then((value) {
    int _count = 0;

    (removeUntil)
        ? Navigator.popUntil(context, (route) => _count++ >= 2)
        : Navigator.pop(context);
  });
}
