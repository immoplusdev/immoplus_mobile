import "package:flutter/material.dart";
import "package:immoplus/app/design_system/design_system.dart";

class TicketCardBackground extends StatelessWidget {
  const TicketCardBackground({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.borderColor,
    this.borderWidth = 1.2,
    this.punchOffsetY = 118.0,
    this.punchRadius = 14.0,
    this.scallopCount = 7,
    this.scallopDepth = 9.0,
  });

  final Widget child;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double punchOffsetY;
  final double punchRadius;
  final int scallopCount;
  final double scallopDepth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TicketBackgroundPainter(
        backgroundColor: backgroundColor,
        borderColor: borderColor ?? AppColors.immoBorderBrandSubtle,
        borderWidth: borderWidth,
        punchOffsetY: punchOffsetY,
        punchRadius: punchRadius,
        scallopCount: scallopCount,
        scallopDepth: scallopDepth,
      ),
      child: child,
    );
  }
}

class _TicketBackgroundPainter extends CustomPainter {
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double punchOffsetY;
  final double punchRadius;
  final int scallopCount;
  final double scallopDepth;

  _TicketBackgroundPainter({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.punchOffsetY,
    required this.punchRadius,
    required this.scallopCount,
    required this.scallopDepth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    // Outer ticket path
    path.moveTo(16, 0);
    path.lineTo(w - 16, 0);
    path.quadraticBezierTo(w, 0, w, 16);

    // Right punch notch
    final punchY = punchOffsetY.clamp(20.0, h - 20.0);
    path.lineTo(w, punchY - punchRadius);
    path.arcToPoint(
      Offset(w, punchY + punchRadius),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );

    path.lineTo(w, h - 16);
    path.quadraticBezierTo(w, h, w - 16, h);

    // Bottom scallops
    final usableW = w - 32;
    final step = usableW / scallopCount;
    for (int i = scallopCount; i > 0; i--) {
      final xEnd = 16 + (i - 1) * step;
      final xMid = 16 + (i - 0.5) * step;
      path.quadraticBezierTo(xMid, h - scallopDepth, xEnd, h);
    }

    path.lineTo(16, h);
    path.quadraticBezierTo(0, h, 0, h - 16);

    // Left punch notch
    path.lineTo(0, punchY + punchRadius);
    path.arcToPoint(
      Offset(0, punchY - punchRadius),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );

    path.lineTo(0, 16);
    path.quadraticBezierTo(0, 0, 16, 0);
    path.close();

    // Fill
    final paintFill = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paintFill);

    // Border
    final paintBorder = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawPath(path, paintBorder);
  }

  @override
  bool shouldRepaint(covariant _TicketBackgroundPainter old) =>
      old.backgroundColor != backgroundColor ||
      old.borderColor != borderColor ||
      old.borderWidth != borderWidth ||
      old.punchOffsetY != punchOffsetY;
}
