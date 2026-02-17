import 'package:flutter/material.dart';

class MapCardOverlayService {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  static void show({
    required BuildContext context,
    required Widget child,
    double bottomPadding = 100,
  }) {
    if (_isShowing) {
      hide();
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: bottomPadding + MediaQuery.of(context).viewPadding.bottom,
        left: 10,
        right: 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isShowing = true;
  }

  static void hide() {
    if (_isShowing && _overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isShowing = false;
    }
  }

  static bool get isShowing => _isShowing;
}
