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
    this.zoom = 13,
    this.initialPosition = const LatLng(5.365162, -4.000802),
    this.isLoading = false,
  });

  MapViwerCubitState copyWith({
    bool? isLoading,
    bool? searchIsFocus,
    List<Marker>? markers,
    List<Polygon>? polygons,
    List<Polyline>? polyline,
    double? zoom,
    LatLng? initialPosition,
  }) {
    return MapViwerCubitState(
      isLoading: isLoading ?? this.isLoading,
      searchIsFocus: searchIsFocus ?? this.searchIsFocus,
      markers: markers ?? this.markers,
      polygons: polygons ?? this.polygons,
      polyline: polyline ?? this.polyline,
      zoom: zoom ?? this.zoom,
      initialPosition: initialPosition ?? this.initialPosition,
    );
  }
}
