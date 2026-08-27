import 'package:flutter/material.dart';

class TicketCardBackground extends StatelessWidget {
  const TicketCardBackground({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xFFD6E2FB),
    this.borderWidth = 1.2,
    this.punchOffsetY = 118.0,
    this.punchRadius = 14.0,
    this.scallopCount = 7,
    this.scallopDepth = 9.0,
  });

  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
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
        borderColor: borderColor,
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

  Path _buildPath(Size size) {
    final path = Path();
    final pad = borderWidth / 2;
    final left = pad;
    final top = pad;
    final right = size.width - pad;
    final bottom = size.height - pad;
    final w = right - left;
    final punchY = (punchOffsetY).clamp(40.0, bottom - 80.0);
    const cornerR = 24.0;
    const cornerBottomR = 14.0;

    // 1. Coin supérieur gauche
    path.moveTo(left, top + cornerR);
    path.arcToPoint(
      Offset(left + cornerR, top),
      radius: const Radius.circular(cornerR),
      clockwise: true,
    );

    // 2. Bord supérieur
    path.lineTo(right - cornerR, top);
    path.arcToPoint(
      Offset(right, top + cornerR),
      radius: const Radius.circular(cornerR),
      clockwise: true,
    );

    // 3. Bord droit jusqu'à l'encoche latérale
    path.lineTo(right, punchY - punchRadius);
    path.arcToPoint(
      Offset(right, punchY + punchRadius),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );

    // 4. Bord droit jusqu'au coin inférieur droit
    path.lineTo(right, bottom - cornerBottomR);
    path.quadraticBezierTo(right, bottom, right - cornerBottomR, bottom);

    // 5. Bord inférieur ondulé continu (de droite à gauche avec tangentes lisses)
    final availableW = w - (2 * cornerBottomR);
    final count = scallopCount.clamp(4, 12);
    final step = availableW / count;
    final handleW = step * 0.22;

    for (int i = 0; i < count; i++) {
      final xStart = (right - cornerBottomR) - (i * step);
      final xEnd = (right - cornerBottomR) - ((i + 1) * step);
      final xMid = (xStart + xEnd) / 2;

      // Montée douce vers le sommet du creux (arche concave)
      path.cubicTo(
        xStart - handleW,
        bottom,
        xMid + handleW,
        bottom - scallopDepth,
        xMid,
        bottom - scallopDepth,
      );

      // Descente douce vers la base du feston
      path.cubicTo(
        xMid - handleW,
        bottom - scallopDepth,
        xEnd + handleW,
        bottom,
        xEnd,
        bottom,
      );
    }

    // 6. Coin inférieur gauche
    path.quadraticBezierTo(left, bottom, left, bottom - cornerBottomR);

    // 7. Bord gauche jusqu'à l'encoche latérale
    path.lineTo(left, punchY + punchRadius);
    path.arcToPoint(
      Offset(left, punchY - punchRadius),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );

    // 8. Fermeture vers le coin supérieur gauche
    path.lineTo(left, top + cornerR);
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildPath(size);

    // 1. Remplissage du fond blanc
    final fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 2. Trait de bordure parfaitement continu et net
    final strokePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _TicketBackgroundPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.punchOffsetY != punchOffsetY ||
        oldDelegate.punchRadius != punchRadius ||
        oldDelegate.scallopCount != scallopCount ||
        oldDelegate.scallopDepth != scallopDepth;
  }
}
