import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CustomPopup {
  static showLoagingToast({String? text, Color? color}) {
    EasyLoading.instance.backgroundColor = color ?? Colors.blue.shade200;
    EasyLoading.show(
      status: text ?? "Envoie...",
      maskType: EasyLoadingMaskType.clear,
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

  static toast(
      {String? text,
      Color? color,
      Widget? errorWidget,
      bool? dismissOnTap,
      EasyLoadingToastPosition? toastPosition}) {
    EasyLoading.instance
      ..errorWidget = errorWidget
      ..backgroundColor = color ?? Colors.red.shade300;
    EasyLoading.showToast(
      text ?? "error",
      dismissOnTap: dismissOnTap,
      toastPosition: toastPosition,
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
