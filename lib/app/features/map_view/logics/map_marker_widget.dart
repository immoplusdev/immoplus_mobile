import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class _Constants {
  // Tailles
  static const Size logicalSize = Size(200, 70);
  static const Size imageSize = Size(600, 210);
  static const double imageWidth = 25;
  static const double imageHeight = 25;
  static const double imageBorderWidth = .5;
  static const double iconSize = 10;
  static const double fontSize = 11;
  static const double arrowWidth = 14;
  static const double arrowHeight = 7;
  static const double borderRadius = 30;
  static const double spacing = 7;

  // Padding
  static const EdgeInsets containerPadding =
      EdgeInsets.symmetric(horizontal: 8, vertical: 5);

  // Timeout
  static const Duration requestTimeout = Duration(seconds: 5);

}

class MapMarkerWidget {
  static final Map<String, BitmapDescriptor> _cache = {};

  static Future<BitmapDescriptor> build({
    required String imageUrl,
    required String price,
    required Color bgColor,
    Color? textColor,
  }) async {
    final cacheKey = '$imageUrl-$price';
    if (_cache.containsKey(cacheKey)) return _cache[cacheKey]!;

    Uint8List? imageBytes;
    try {
      final file = await DefaultCacheManager()
          .getSingleFile(imageUrl)
          .timeout(_Constants.requestTimeout);
      imageBytes = await file.readAsBytes();
    } catch (_) {}

    final descriptor = await _MarkerWidget(
      imageBytes: imageBytes,
      price: price,
      bgColor: bgColor,
      textColor: textColor,
    ).toBitmapDescriptor(
      logicalSize: _Constants.logicalSize,
      imageSize: _Constants.imageSize,
    );

    _cache[cacheKey] = descriptor;
    return descriptor;
  }

  static void clearCache() => _cache.clear();
}

class _MarkerWidget extends StatelessWidget {
  const _MarkerWidget({
    required this.imageBytes,
    required this.price,
    required this.bgColor,
    required this.textColor,
  });

  final Uint8List? imageBytes;
  final String price;
  final Color bgColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: _Constants.containerPadding,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(_Constants.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildImage(),
              SizedBox(width: _Constants.spacing),
              _buildPrice(),
            ],
          ),
        ),
        CustomPaint(
          size: const Size(_Constants.arrowWidth, _Constants.arrowHeight),
          painter: _ArrowPainter(color: bgColor),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return Container(
      width: _Constants.imageWidth,
      height: _Constants.imageHeight,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: textColor ?? Colors.white,
          width: _Constants.imageBorderWidth,
        ),
      ),
      child: ClipOval(
        child: imageBytes != null
            ? Image.memory(imageBytes!, fit: BoxFit.cover)
            : Container(
                color: Colors.white24,
                child: Icon(
                  Icons.home_rounded,
                  color: textColor ?? Colors.white,
                  size: _Constants.iconSize,
                ),
              ),
      ),
    );
  }

  Widget _buildPrice() {
    return Text(
      price,
      style: TextStyle(
        color: textColor ?? Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: _Constants.fontSize,
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final Color color;
  const _ArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width / 2, size.height)
        ..close(),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_ArrowPainter old) => old.color != color;
}
