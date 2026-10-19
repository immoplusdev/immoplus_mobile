import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/data/models/remote/messaging/message_model.dart';
import 'package:immoplus/app/design_system/design_system.dart';

class LocationCardMessage extends StatelessWidget {
  const LocationCardMessage({super.key, required this.message});

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final location = _ApproximateLocation.fromPayload(message.payload);
    final rawCta = message.payload['cta'];
    final ctaLabel =
        rawCta is Map && rawCta['label']?.toString().trim().isNotEmpty == true
            ? rawCta['label'].toString().trim()
            : 'Voir sur la carte';
    final alignment =
        message.isFromClient ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.only(
          left: message.isFromClient ? 48 : 16,
          right: message.isFromClient ? 16 : 48,
          top: 4,
          bottom: 4,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.78,
          ),
          child: Material(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _showMapSheet(context, location),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.immoBorderDefault),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MapPreview(location: location, height: 132),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.font(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            location.area == null
                                ? 'Localisation approximative'
                                : '${location.area} • zone proche',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.font(
                              fontSize: 12,
                              color: AppColors.immoTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.map_1,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                ctaLabel,
                                style: AppTypography.font(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMapSheet(
    BuildContext context,
    _ApproximateLocation location,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: AppColors.white,
      builder: (context) => _LocationMapSheet(location: location),
    );
  }
}

class _ApproximateLocation {
  const _ApproximateLocation({
    required this.label,
    required this.area,
    required this.center,
    required this.zoom,
  });

  final String label;
  final String? area;
  final LatLng? center;
  final double zoom;

  factory _ApproximateLocation.fromPayload(Map<String, dynamic> payload) {
    final location = payload['location'];
    final lat = _coordinate(location is Map ? location['lat'] : null);
    final lng = _coordinate(location is Map ? location['lng'] : null);
    final isValidPosition = lat != null &&
        lng != null &&
        lat >= -90 &&
        lat <= 90 &&
        lng >= -180 &&
        lng <= 180;
    final isApproximate =
        payload['precision']?.toString().toLowerCase() == 'approximate' ||
            payload['hideExactAddress'] == true;
    final rawZoom = _coordinate(payload['zoom']);

    return _ApproximateLocation(
      label: _safeLabel(payload['label']) ??
          _safeLabel(payload['area']) ??
          'Localisation approximative',
      area: _safeLabel(payload['area']),
      center: isValidPosition && isApproximate
          ? LatLng(_roundToZone(lat), _roundToZone(lng))
          : null,
      zoom: (rawZoom ?? 12).clamp(10, 13).toDouble(),
    );
  }

  static double _roundToZone(double coordinate) =>
      (coordinate * 100).roundToDouble() / 100;

  static double? _coordinate(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  static String? _safeLabel(dynamic value) {
    final label = value?.toString().trim();
    if (label == null || label.isEmpty || label == 'null') return null;
    return label;
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview({required this.location, required this.height});

  final _ApproximateLocation location;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (location.center case final center?)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: center,
                zoom: location.zoom,
              ),
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              scrollGesturesEnabled: false,
              zoomGesturesEnabled: false,
              liteModeEnabled: true,
            )
          else
            const _FallbackMap(),
          const IgnorePointer(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 18),
                child: Icon(
                  Iconsax.location,
                  size: 38,
                  color: Color(0xFFE45B4F),
                  shadows: [Shadow(color: Colors.white, blurRadius: 5)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationMapSheet extends StatelessWidget {
  const _LocationMapSheet({required this.location});

  final _ApproximateLocation location;

  @override
  Widget build(BuildContext context) {
    final mapHeight =
        (MediaQuery.sizeOf(context).height * 0.58).clamp(300, 520);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            location.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.font(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            location.area == null
                ? 'Localisation approximative'
                : '${location.area} • zone proche',
            style: AppTypography.font(
              fontSize: 13,
              color: AppColors.immoTextSecondary,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: mapHeight.toDouble(),
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (location.center case final center?)
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: center,
                        zoom: location.zoom,
                      ),
                      minMaxZoomPreference: const MinMaxZoomPreference(10, 13),
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      compassEnabled: true,
                      mapToolbarEnabled: false,
                      markers: {
                        Marker(
                          markerId: const MarkerId('approximate-location'),
                          position: center,
                          infoWindow: InfoWindow(title: location.label),
                        ),
                      },
                    )
                  else
                    const _FallbackMap(),
                  if (location.center == null)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Carte détaillée indisponible pour cette zone',
                          textAlign: TextAlign.center,
                          style: AppTypography.font(
                            fontSize: 13,
                            color: AppColors.immoTextSecondary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Position approximative. Aucune adresse exacte n’est affichée.',
            style: AppTypography.font(
              fontSize: 12,
              color: AppColors.immoTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FallbackMap extends StatelessWidget {
  const _FallbackMap();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      painter: _FallbackMapPainter(),
      child: SizedBox.expand(),
    );
  }
}

class _FallbackMapPainter extends CustomPainter {
  const _FallbackMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFE9EFEA), BlendMode.src);
    final parkPaint = Paint()..color = const Color(0xFFD5E4D1);
    final waterPaint = Paint()..color = const Color(0xFFC9E0E7);
    final roadPaint = Paint()
      ..color = const Color(0xFFF8F7F1)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final thinRoadPaint = Paint()
      ..color = const Color(0xFFF8F7F1)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.06, size.height * 0.12, size.width * 0.28,
          size.height * 0.32),
      parkPaint,
    );
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.67, size.height * 0.55, size.width * 0.4,
          size.height * 0.42),
      parkPaint,
    );
    final water = Path()
      ..moveTo(size.width * 0.8, 0)
      ..cubicTo(size.width * 0.68, size.height * 0.25, size.width * 0.98,
          size.height * 0.55, size.width * 0.78, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(water, waterPaint);

    final roads = [
      Path()
        ..moveTo(-10, size.height * 0.78)
        ..cubicTo(size.width * 0.25, size.height * 0.58, size.width * 0.58,
            size.height * 0.93, size.width + 10, size.height * 0.35),
      Path()
        ..moveTo(size.width * 0.18, -10)
        ..cubicTo(size.width * 0.38, size.height * 0.35, size.width * 0.2,
            size.height * 0.62, size.width * 0.48, size.height + 10),
      Path()
        ..moveTo(-10, size.height * 0.25)
        ..lineTo(size.width * 0.72, size.height * 0.48),
      Path()
        ..moveTo(size.width * 0.53, -10)
        ..lineTo(size.width * 0.42, size.height + 10),
    ];
    for (var index = 0; index < roads.length; index++) {
      canvas.drawPath(roads[index], index < 2 ? roadPaint : thinRoadPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
