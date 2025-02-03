import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class EasyLoadingHandler {
  init() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..backgroundColor = Colors.blue.shade400 // Couleur du fond
      ..textColor = Colors.black // Couleur du texte
      ..indicatorColor = CupertinoColors.black
      ..radius = 20
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle =
          EasyLoadingStyle.custom; // Utiliser le style personnalisé
  }

  static showLoagingToast({String? text, Color? color, bool? dismissOnTap}) {
    EasyLoading.instance.backgroundColor = color ?? Colors.blue.shade200;
    EasyLoading.show(
      status: text ?? "Envoie...",
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: dismissOnTap ?? false,
    );
  }

  static showErrorToast(
      {String? text, Color? color, Widget? errorWidget, bool? dismissOnTap}) {
    EasyLoading.instance
      ..errorWidget = errorWidget
      ..backgroundColor = color ?? Colors.red.shade300;
    EasyLoading.showError(
      text ?? "error",
      dismissOnTap: dismissOnTap,
    );
  }

  static showSuccesToast(
      {String? text, Color? color, Widget? errorWidget, bool? dismissOnTap}) {
    EasyLoading.instance
      ..errorWidget = errorWidget
      ..backgroundColor = color ?? Colors.green.shade400;
    EasyLoading.showSuccess(
      text ?? "Success",
      dismissOnTap: dismissOnTap,
    );
  }
}
