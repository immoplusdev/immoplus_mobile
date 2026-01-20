import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/force_update_required_page.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:new_version_plus/model/version_status.dart';
import 'package:new_version_plus/new_version_plus.dart';

class UpdateService {
  // Identifiants de ton app (modifie si nécessaire)
  static const String androidAppId = 'com.immoplus.ci';
  static const String iosAppId = 'com.immoplus.ci';

  final NewVersionPlus _newVersion = NewVersionPlus(
    androidId: androidAppId,
    iOSId: iosAppId,
  );

  Future<void> checkForUpdate(BuildContext context,
      {bool forceUpdate = false}) async {
    try {
      final status = await _newVersion.getVersionStatus();

      if (status != null && status.canUpdate) {
        if (forceUpdate) {
          context.pushNamed(ForceUpdateRequiredPage.name, extra: () {
            _onTapUpdateButton(status);
          });
        } else {
          _showUpdateDialog(context, status);
        }
      }
    } catch (e) {
      debugPrint(
          "=======checkForUpdate Erreur lors de la vérification de mise à jour : $e");
    }
  }

  void _showUpdateDialog(BuildContext context, VersionStatus status) {
    final message =
        "Une nouvelle version de votre app est disponible. Elle contient des améliorations importantes pour votre expérience.";
    AppDialog.info(
      content: message,
      icon: Icon(Icons.cloud_upload_outlined),
      barrierDismissible: true,
      rollback: () {
        _onTapUpdateButton(status);
      },
      textButton: "Mettre à jour maintenant",
    );
  }

  _onTapUpdateButton(VersionStatus status) {
    _newVersion.launchAppStore(status.appStoreLink);
  }
}
