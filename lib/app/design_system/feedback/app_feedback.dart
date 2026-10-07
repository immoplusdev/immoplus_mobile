import 'package:flutter/material.dart';
import 'package:immoplus/app/design_system/feedback/easy_loading_handler.dart';
import 'package:immoplus/app/design_system/feedback/toast_utils.dart';
import 'package:immoplus/app/design_system/feedback/widgets/app_dialog.dart';

/// Point d'entrée unique et harmonisé pour toutes les notifications et alertes UI.
///
/// Implémente la règle des 3 canaux :
/// 1. Feedback transitoire non bloquant (Toasts Figma)
/// 2. Feedback bloquant / décisionnel (Modales AppDialog)
/// 3. Feedback inline (Formulaires & Empty states)
/// + Indicateurs de chargement centralisés (EasyLoadingHandler)
class AppFeedback {
  AppFeedback._();

  // ── 0. Chargement (Overlays) ──

  /// Affiche l'indicateur de chargement plein écran
  static void showLoading({String? text, bool dismissOnTap = false}) {
    EasyLoadingHandler.show(text: text, dismissOnTap: dismissOnTap);
  }

  /// Masque l'indicateur de chargement
  static void dismissLoading() {
    EasyLoadingHandler.dismiss();
  }

  // ── 1. Toasts Transitoires (Non bloquants) ──

  /// Affiche une notification d'erreur transitoire (Figma Toast)
  static void showError(String message, {String? title, Duration? duration}) {
    ToastUtils.showError(
      title: title ?? "Erreur",
      description: message,
      duration: duration,
    );
  }

  /// Affiche une notification de succès transitoire (Figma Toast)
  static void showSuccess(String message, {String? title, Duration? duration}) {
    ToastUtils.showSuccess(
      title: title ?? "Succès",
      description: message,
      duration: duration,
    );
  }

  /// Affiche une notification d'information transitoire (Figma Toast)
  static void showInfo(String title,
      {String? description, Duration? duration}) {
    ToastUtils.showInfo(
      title: title,
      description: description,
      duration: duration,
    );
  }

  /// Affiche une notification d'avertissement transitoire (Figma Toast)
  static void showWarning(String title,
      {String? description, Duration? duration}) {
    ToastUtils.showWarning(
      title: title,
      description: description,
      duration: duration,
    );
  }

  // ── 2. Modales Bloquantes (Décisions & Erreurs Critiques) ──

  /// Affiche une boîte de dialogue de confirmation d'action
  static Future<void> showConfirmDialog({
    required BuildContext context,
    required String message,
    bool isDestructiveAction = false,
    VoidCallback? onConfirm,
  }) async {
    await AppDialog.confirm(
      context: context,
      content: message,
      isDestructiveAction: isDestructiveAction,
      rollback: onConfirm,
    );
  }

  /// Affiche un dialogue d'information standardisé
  static Future<void> showInfoDialog({
    required String title,
    required String description,
    required String buttonText,
    String? secondaryButtonText,
    VoidCallback? onPrimary,
    VoidCallback? onSecondary,
  }) async {
    await AppDialog.show(
      title: title,
      description: description,
      primaryButtonText: buttonText,
      secondButtonText: secondaryButtonText,
      onPrimary: onPrimary,
      onSecond: onSecondary,
    );
  }

  /// Ferme tous les feedbacks ouverts
  static void dismissAll() {
    ToastUtils.dismissAll();
  }
}
