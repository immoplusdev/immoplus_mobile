import 'package:flutter/material.dart';

const kDefaultPadding = 25.0;

extension SafeAreaExtensions on Widget {
  Widget safeArea() => SafeArea(
        top: false,
        child: this,
      );

  Widget get addBottomSpace {
    return SafeArea(
      top: false,
      child: Center(
        child: this,
      ),
    );
  }
}
