import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViwerCubitState {
  final bool isLoading;
  final bool searchIsFocus;
  final List<Marker>? markers;
  final List<Polygon>? polygons;
  final List<Polyline>? polyline;
  final double zoom;
  final LatLng initialPosition;

  MapViwerCubitState({
    this.markers = const [],
    this.polygons = const [],
    this.polyline = const [],
    this.searchIsFocus = false,
    this.zoom = 11.6,
    this.initialPosition = const LatLng(5.365162, -4.000802),
    this.isLoading = false,
  });
}
