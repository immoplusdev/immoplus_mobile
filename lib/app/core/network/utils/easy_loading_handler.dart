import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';
import 'package:lottie/lottie.dart';

@lazySingleton
class EasyLoadingHandler {
  init() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..backgroundColor = Colors.white // Fond blanc
      ..textColor = Colors.black // Texte noir
      ..indicatorColor = Colors.black
      ..radius = 16
      ..maskType = EasyLoadingMaskType.black // Assombrit le fond pour focus
      ..indicatorWidget = SizedBox(
        height: 100,
        width: 100,
        child: Lottie.asset(
          'assets/animations/immo-loading.json',
          fit: BoxFit.contain,
        ),
      )
      ..loadingStyle = EasyLoadingStyle.custom; // Style personnalisé
  }

  static showLoadingToast({String? text, Color? color, bool? dismissOnTap}) {
    EasyLoading.instance
      ..backgroundColor = color ?? Colors.white
      ..textColor = Colors.black;
    EasyLoading.show(
      status: text ?? "Envoie...",
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: dismissOnTap ?? false,
    );
  }

  static hideLoadingToast() {
    EasyLoading.dismiss();
  }

  static showErrorToast(
      {String? text, Color? color, Widget? errorWidget, bool? dismissOnTap}) {
    EasyLoading.instance
      ..errorWidget = errorWidget
      ..backgroundColor = color ?? Colors.white
      ..textColor = Colors.red;
    EasyLoading.showError(
      text ?? "Erreur",
      dismissOnTap: dismissOnTap,
    );
  }

  static showSuccessToast(
      {String? text, Color? color, Widget? errorWidget, bool? dismissOnTap}) {
    EasyLoading.instance
      ..errorWidget = errorWidget
      ..backgroundColor = color ?? Colors.white
      ..textColor = Colors.black;
    EasyLoading.showSuccess(
      text ?? "Succès",
      dismissOnTap: dismissOnTap,
    );
  }

  static toast(
      {String? text,
      Widget? errorWidget,
      bool? dismissOnTap,
      EasyLoadingToastPosition? toastPosition}) {
    EasyLoading.instance.errorWidget = errorWidget;
    EasyLoading.showToast(
      text ?? "Message",
      dismissOnTap: dismissOnTap,
      toastPosition: toastPosition,
    );
  }
}
