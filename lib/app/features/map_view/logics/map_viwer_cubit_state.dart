import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViwerCubitState {
  final bool isLoading;
  final bool searchIsFocus;
  final bool needsManualRefresh;
  final bool showRoute;
  final bool showSearchButton;
  final String? routeDistance;
  final String? routeDuration;
  final List<Marker>? markers;
  final List<Polygon>? polygons;
  final List<Polyline>? polyline;
  final double zoom;
  final LatLng initialPosition;
  final int markerCount;

  MapViwerCubitState({
    this.markers = const [],
    this.polygons = const [],
    this.polyline = const [],
    this.searchIsFocus = false,
    this.needsManualRefresh = false,
    this.showRoute = false,
    this.showSearchButton = false,
    this.routeDistance,
    this.routeDuration,
    this.zoom = 13,
    this.initialPosition = const LatLng(5.365162, -4.000802),
    this.isLoading = false,
    this.markerCount = 0,
  });

  /// [clearRoute] — passer `true` pour forcer routeDistance/routeDuration à null
  MapViwerCubitState copyWith({
    bool? isLoading,
    bool? searchIsFocus,
    bool? needsManualRefresh,
    bool? showRoute,
    bool? showSearchButton,
    String? routeDistance,
    String? routeDuration,
    bool clearRoute = false,
    List<Marker>? markers,
    List<Polygon>? polygons,
    List<Polyline>? polyline,
    double? zoom,
    LatLng? initialPosition,
    int? markerCount,
  }) {
    return MapViwerCubitState(
      isLoading: isLoading ?? this.isLoading,
      searchIsFocus: searchIsFocus ?? this.searchIsFocus,
      needsManualRefresh: needsManualRefresh ?? this.needsManualRefresh,
      showRoute: showRoute ?? this.showRoute,
      showSearchButton: showSearchButton ?? this.showSearchButton,
      routeDistance: clearRoute ? null : (routeDistance ?? this.routeDistance),
      routeDuration: clearRoute ? null : (routeDuration ?? this.routeDuration),
      markers: markers ?? this.markers,
      polygons: polygons ?? this.polygons,
      polyline: polyline ?? this.polyline,
      zoom: zoom ?? this.zoom,
      initialPosition: initialPosition ?? this.initialPosition,
      markerCount: markerCount ?? this.markerCount,
    );
  }
}
