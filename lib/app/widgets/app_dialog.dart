import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';

class AppDialog {
  static Future info(
          {required String content,
          required Widget icon,
          void Function()? rollback,
          bool barrierDismissible = false,
          bool isDestructiveAction = false,
          String? textButton}) async =>
      showCupertinoModalPopup(
        barrierDismissible: barrierDismissible,
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
              isDestructiveAction: isDestructiveAction,
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
          bool barrierDismissible = false,
          bool isDestructiveAction = false,
          void Function()? rollback}) async =>
      showCupertinoModalPopup(
        barrierDismissible: barrierDismissible,
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
              isDestructiveAction: isDestructiveAction,
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

  /// Dialog avec titre, description, bouton primaire (filled) et bouton secondaire optionnel (outlined).
  /// Le bouton secondaire s'affiche au-dessus du bouton primaire.
  static Future<void> show({
    required String title,
    required String description,
    required String primaryButtonText,
    String? secondButtonText,
    VoidCallback? onPrimary,
    VoidCallback? onSecond,
    bool barrierDismissible = true,
  }) {
    return showDialog<void>(
      context: NavigationService.navigatorKey.currentContext!,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                     CustomButtom(
                  text: primaryButtonText,
                  borderRadius: BorderRadius.circular(28),
                  onClick: () {
                    Navigator.of(ctx).pop();
                    onPrimary?.call();
                  },
                ),
                 const SizedBox(height: 10),
                if (secondButtonText != null) ...[
                  SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        onSecond?.call();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        secondButtonText,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                 
                ],
           
              ],
            ),
          ),
        );
      },
    );
  }

  /// Affiche une boîte de dialogue proposant d'ouvrir les paramètres système.
  static void showOpenSettingsDialog(BuildContext context) {
    show(
      title: 'Voulez-vous ouvrir les paramètres ?',
      description: 'Pour voir les permissions veuillez ouvrir les paramètres',
      secondButtonText: 'Retour',
      primaryButtonText: 'Paramètres',
      onPrimary: openAppSettings,
    );
  }
}
