import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus/app/design_system/design_system.dart';

class CustomPopup {
  static showLoagingToast({String? text, Color? color}) {
    EasyLoadingHandler.showLoadingToast(
      text: text ?? "Envoie...",
    );
  }

  static hideLoadingToast() {
    EasyLoading.dismiss();
  }

  static showErrorToast(
      {String? text, Color? color, Widget? errorWidget, bool? dismissOnTap}) {
    EasyLoadingHandler.showErrorToast(
      text: text ?? "error",
      dismissOnTap: dismissOnTap,
    );
  }

  static toast(
      {String? text,
      Color? color,
      Widget? errorWidget,
      bool? dismissOnTap,
      EasyLoadingToastPosition? toastPosition}) {
    EasyLoadingHandler.toast(
      text: text ?? "error",
      dismissOnTap: dismissOnTap,
      toastPosition: toastPosition,
    );
  }

  static showSuccesToast(
      {String? text, Color? color, Widget? errorWidget, bool? dismissOnTap}) {
    EasyLoadingHandler.showSuccessToast(
      text: text ?? "Success",
      dismissOnTap: dismissOnTap,
    );
  }
}
