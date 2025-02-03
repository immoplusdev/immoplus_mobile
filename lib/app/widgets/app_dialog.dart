import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/services/navigation_service.dart';

class AppDialog {
  static Future info(
          {required String content,
          required Widget icon,
          void Function()? rollback,
          String? textButton}) async =>
      showCupertinoModalPopup(
        barrierDismissible: false,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (context) => CupertinoAlertDialog(
          title: icon,
          content: Text(
            content,
            style: GoogleFonts.inter(
              //fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: false,
              onPressed: rollback ??
                  () {
                    Navigator.pop(context);
                  },
              child: Text(textButton ?? 'OK'),
            ),
          ],
        ),
      ).then((value) {
        print('TOTO');
      });

  static Future confirm(
          {required BuildContext context,
          required String content,
          void Function()? rollback}) async =>
      showCupertinoModalPopup(
        barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Icon(
            CupertinoIcons.exclamationmark_triangle,
            color: Colors.red,
          ),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Retour'),
              onPressed: () {
                context.pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Confirmer'),
              onPressed: rollback ??
                  () {
                    context.pop();
                  },
            ),
          ],
        ),
      ).then((value) {
        print('TOTO');
      });
}
