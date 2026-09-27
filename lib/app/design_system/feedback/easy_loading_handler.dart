import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus/app/design_system/tokens/app_colors.dart';
import 'package:injectable/injectable.dart';
import 'package:lottie/lottie.dart';

/// Gestionnaire centralisé des overlays de chargement pour ImmoPlus.
///
/// Encapsule `flutter_easyloading` pour éviter tout appel direct et arbitraire
/// depuis les composants ou dépôts de données.
@lazySingleton
class EasyLoadingHandler {
  /// Initialise le style global de l'indicateur de chargement (Lottie animation).
  Future<void> init() async {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..backgroundColor = AppColors.white
      ..textColor = AppColors.immoTextPrimary
      ..indicatorColor = AppColors.primary
      ..radius = 16
      ..maskType = EasyLoadingMaskType.black
      ..indicatorWidget = SizedBox(
        height: 100,
        width: 100,
        child: Lottie.asset(
          'assets/animations/immo-loading.json',
          fit: BoxFit.contain,
        ),
      )
      ..loadingStyle = EasyLoadingStyle.custom;
  }

  /// Initialiseur pour le `builder` de `MaterialApp`.
  static TransitionBuilder initBuilder([TransitionBuilder? builder]) {
    return EasyLoading.init(builder: builder);
  }

  /// Affiche l'overlay de chargement plein écran avec animation Lottie.
  static void show({String? text, bool dismissOnTap = false}) {
    EasyLoading.instance
      ..backgroundColor = AppColors.white
      ..textColor = AppColors.immoTextPrimary;
    EasyLoading.show(
      status: text ?? "Chargement...",
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: dismissOnTap,
    );
  }

  /// Masque l'overlay de chargement.
  static void dismiss() {
    EasyLoading.dismiss();
  }

  // ── Alias de compatibilité ascendante ──

  /// Alias pour [show].
  static void showLoadingToast({String? text, Color? color, bool? dismissOnTap}) {
    show(text: text ?? "Envoi...", dismissOnTap: dismissOnTap ?? false);
  }

  /// Alias pour [dismiss].
  static void hideLoadingToast() {
    dismiss();
  }

  /// Affiche une erreur (déléguée de manière contrôlée).
  static void showErrorToast({
    String? text,
    Color? color,
    Widget? errorWidget,
    bool? dismissOnTap,
  }) {
    EasyLoading.instance
      ..errorWidget = errorWidget
      ..backgroundColor = color ?? AppColors.white
      ..textColor = AppColors.error;
    EasyLoading.showError(
      text ?? "Erreur",
      dismissOnTap: dismissOnTap,
    );
  }

  /// Affiche un succès (délégué de manière contrôlée).
  static void showSuccessToast({
    String? text,
    Color? color,
    Widget? errorWidget,
    bool? dismissOnTap,
  }) {
    EasyLoading.instance
      ..errorWidget = errorWidget
      ..backgroundColor = color ?? AppColors.white
      ..textColor = AppColors.immoTextPrimary;
    EasyLoading.showSuccess(
      text ?? "Succès",
      dismissOnTap: dismissOnTap,
    );
  }

  /// Affiche un toast rapide.
  static void toast({
    String? text,
    Widget? errorWidget,
    bool? dismissOnTap,
    EasyLoadingToastPosition? toastPosition,
  }) {
    EasyLoading.instance.errorWidget = errorWidget;
    EasyLoading.showToast(
      text ?? "Message",
      dismissOnTap: dismissOnTap,
      toastPosition: toastPosition,
    );
  }
}
