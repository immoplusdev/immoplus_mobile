import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/core/error/error_presenter.dart';
import 'package:immoplus/app/design_system/design_system.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ErrorPresenter)
class UiErrorPresenter implements ErrorPresenter {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  @override
  Future<void> showDialog({
    required String title,
    required String message,
    String? actionLabel,
    FutureOr<void> Function()? onAction,
    String? reference,
  }) {
    return AppErrorDialog.show(
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction == null ? null : () => onAction(),
      reference: reference,
    );
  }

  @override
  void showToast({required String title, required String message}) {
    ToastUtils.showError(title: title, description: message);
  }

  bool _offlineDialogOpen = false;

  @override
  Future<void> showOfflineDialog({
    FutureOr<void> Function()? onRestored,
  }) async {
    if (_offlineDialogOpen) return;
    _offlineDialogOpen = true;

    _connectivitySub?.cancel();
    _connectivitySub = Connectivity().onConnectivityChanged.listen(
      (results) async {
        if (results.every((r) => r == ConnectivityResult.none)) return;
        _connectivitySub?.cancel();
        _connectivitySub = null;
        hideOfflineDialog();
        // Laisse le réseau devenir réellement utilisable avant de relancer.
        await Future<void>.delayed(const Duration(seconds: 1));
        await onRestored?.call();
      },
    );

    try {
      await AppErrorDialog.show(
        title: 'Pas de connexion',
        message: onRestored == null
            ? 'Vérifiez votre connexion internet puis réessayez.'
            : 'Vérifiez votre connexion internet. Votre demande sera '
                'relancée automatiquement dès le retour du réseau.',
      );
    } finally {
      _offlineDialogOpen = false;
      _connectivitySub?.cancel();
      _connectivitySub = null;
    }
  }

  @override
  void hideOfflineDialog() {
    if (!_offlineDialogOpen) return;
    final context = NavigationService.navigatorKey.currentContext;
    if (context != null) {
      Navigator.of(context, rootNavigator: true).maybePop();
    }
  }

  @override
  void openSignIn() {
    AppRouter.router.pushNamed(AuthenticationPage.name);
  }
}
