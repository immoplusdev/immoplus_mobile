import 'package:flutter/material.dart';

class CustomMarker extends StatelessWidget {
  // Declare a global key and get it through Constructor
  const CustomMarker(this.globalKeyMyWidget, {super.key});
  final GlobalKey globalKeyMyWidget;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKeyMyWidget,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Bottom pointer (triangle)
          Positioned(
            bottom: 0,
            child: CustomPaint(
              size: const Size(50, 50), // Adjust size as needed
              painter: _TrianglePainter(),
            ),
          ),
          // Top circle
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.accessibility,
                  color: Colors.white,
                  size: 35,
                ),
                Text(
                  'Widget',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the triangle
class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0); // Top point of the triangle
    path.lineTo(0, size.height); // Bottom-left
    path.lineTo(size.width, size.height); // Bottom-right
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
