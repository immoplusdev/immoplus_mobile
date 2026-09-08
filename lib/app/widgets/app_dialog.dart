import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/configs/app_typography.dart';
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
            style: AppTypography.h4.copyWith(
              color: AppColors.black,
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
          title: const Icon(
            CupertinoIcons.exclamationmark_triangle,
            color: AppColors.red,
          ),
          content: Text(
            content,
            style: AppTypography.bodyMedium,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Retour'),
              onPressed: () {
                context.pop();
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: isDestructiveAction,
              onPressed: rollback ??
                  () {
                    context.pop();
                  },
              child: const Text('Confirmer'),
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
      barrierColor: AppColors.black.withValues(alpha: 0.5),
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: AppColors.white,
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
                  style: AppTypography.h4.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
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
                        style: AppTypography.button.copyWith(
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
