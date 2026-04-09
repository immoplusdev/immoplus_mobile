import 'package:flutter/material.dart';
import 'package:immoplus/app/core/services/navigation_service.dart';
import 'package:immoplus/app/widgets/figma_toast.dart';
import 'package:toastification/toastification.dart';

class ToastUtils {
  /// Durée par défaut des toasts
  static const Duration _defaultDuration = Duration(seconds: 5);

  /// Affiche un toast d'erreur
  static void showError({
    String? title,
    String? description,
    Duration? duration,
    Alignment? alignment,
  }) {
    showCustomToast(
      type: FigmaToastType.error,
      title: title ?? "Erreur",
      description: description,
      duration: duration,
      alignment: alignment,
    );
  }

  /// Affiche un toast de succès
  static void showSuccess({
    String? title,
    String? description,
    Duration? duration,
    Alignment? alignment,
  }) {
    showCustomToast(
      type: FigmaToastType.success,
      title: title ?? "Succès",
      description: description,
      duration: duration,
      alignment: alignment,
    );
  }

  /// Affiche un toast d'information
  static void showInfo({
    required String title,
    String? description,
    Duration? duration,
    Alignment? alignment,
  }) {
    showCustomToast(
      type: FigmaToastType.info,
      title: title,
      description: description,
      duration: duration,
      alignment: alignment,
    );
  }

  /// Affiche un toast d'avertissement
  static void showWarning({
    required String title,
    String? description,
    Duration? duration,
    Alignment? alignment,
  }) {
    showCustomToast(
      type: FigmaToastType.warning,
      title: title,
      description: description,
      duration: duration,
      alignment: alignment,
    );
  }

  /// Toast d'erreur rapide (méthode raccourcie)
  static void error(String? message) {
    showError(description: message ?? "Une erreur est survenue");
  }

  /// Toast de succès rapide (méthode raccourcie)
  static void success(String? message) {
    showSuccess(description: message ?? "Opération effectuée avec succès");
  }

  /// Toast d'info rapide (méthode raccourcie)
  static void info(String message) {
    showInfo(title: message);
  }

  /// Toast d'avertissement rapide (méthode raccourcie)
  static void warning(String message) {
    showWarning(title: message);
  }

  static void showCustomToast({
    required FigmaToastType type,
    required String title,
    String? description,
    Duration? duration,
    Alignment? alignment,
  }) {
    toastification.showCustom(
      context: NavigationService.navigatorKey.currentContext,
      autoCloseDuration: duration ?? _defaultDuration,
      alignment: alignment ?? Alignment.bottomCenter,
      builder: (context, holder) => FigmaToast(
        type: type,
        title: title,
        description: description,
        holder: holder,
      ),
    );
  }

  /// Ferme tous les toasts
  static void dismissAll() {
    toastification.dismissAll();
  }
}
