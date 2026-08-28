import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    this.icon,
    required this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.iconWidget,
  });

  final IconData? icon;
  final Widget? iconWidget;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white.withOpacity(0.92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: iconWidget ??
            Icon(
              icon,
              size: 20,
              color: iconColor ?? const Color(0xFF222222),
            ),
      ),
    );
  }
}
