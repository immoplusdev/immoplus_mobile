import 'package:flutter/material.dart';
import 'package:immoplus/app/core/services/navigation_service.dart';
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
    bool showProgressBar = false,
    ToastificationStyle style = ToastificationStyle.flatColored,
  }) {
    toastification.show(
      type: ToastificationType.error,
      context: NavigationService.navigatorKey.currentContext,
      title: title != null ? Text(title) : null,
      description: description != null ? Text(description) : null,
      autoCloseDuration: duration ?? _defaultDuration,
      showProgressBar: showProgressBar,
      alignment: alignment ?? Alignment.bottomCenter,
      style: style,
    );
  }

  /// Affiche un toast de succès
  static void showSuccess({
    String? title,
    String? description,
    Duration? duration,
    Alignment? alignment,
    bool showProgressBar = false,
    ToastificationStyle style = ToastificationStyle.flatColored,
  }) {
    toastification.show(
      type: ToastificationType.success,
      context: NavigationService.navigatorKey.currentContext,
      title: title != null ? Text(title) : null,
      description: description != null ? Text(description) : null,
      autoCloseDuration: duration ?? _defaultDuration,
      showProgressBar: showProgressBar,
      alignment: alignment ?? Alignment.bottomCenter,
      style: style,
    );
  }

  /// Affiche un toast d'information
  static void showInfo({
    required String title,
    String? description,
    Duration? duration,
    Alignment? alignment,
    bool showProgressBar = false,
    ToastificationStyle style = ToastificationStyle.flatColored,
  }) {
    toastification.show(
      type: ToastificationType.info,
      context: NavigationService.navigatorKey.currentContext,
      title: Text(title),
      description: description != null ? Text(description) : null,
      autoCloseDuration: duration ?? _defaultDuration,
      showProgressBar: showProgressBar,
      alignment: alignment ?? Alignment.bottomCenter,
      style: style,
    );
  }

  /// Affiche un toast d'avertissement
  static void showWarning({
    required String title,
    String? description,
    Duration? duration,
    Alignment? alignment,
    bool showProgressBar = false,
    ToastificationStyle style = ToastificationStyle.flatColored,
  }) {
    toastification.show(
      type: ToastificationType.warning,
      context: NavigationService.navigatorKey.currentContext,
      title: Text(title),
      description: description != null ? Text(description) : null,
      autoCloseDuration: duration ?? _defaultDuration,
      showProgressBar: showProgressBar,
      alignment: alignment ?? Alignment.bottomCenter,
      style: style,
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

  /// Toast avec style personnalisé
  static void showCustom({
    required ToastificationType type,
    required String title,
    String? description,
    Duration? duration,
    Alignment? alignment,
    bool showProgressBar = false,
    ToastificationStyle style = ToastificationStyle.flatColored,
    Widget? icon,
    Color? primaryColor,
    Color? backgroundColor,
  }) {
    toastification.show(
      type: type,
      context: NavigationService.navigatorKey.currentContext,
      title: Text(title),
      description: description != null ? Text(description) : null,
      autoCloseDuration: duration ?? _defaultDuration,
      showProgressBar: showProgressBar,
      alignment: alignment ?? Alignment.bottomCenter,
      style: style,
      icon: icon,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
    );
  }

  /// Ferme tous les toasts
  static void dismissAll() {
    toastification.dismissAll();
  }
}
