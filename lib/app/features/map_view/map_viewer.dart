import 'dart:async';
import 'dart:math';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:immoplus/app/features/map_view/logics/map_card_overlay_service.dart';
import 'package:immoplus/app/features/map_view/logics/map_viwer.cubit.dart';
import 'package:immoplus/app/features/map_view/logics/map_viwer_cubit_state.dart';
import 'package:immoplus/app/services/location_service.dart';
import 'package:immoplus/app/widgets/map/location_permission_banner.dart';
import 'package:immoplus/app/features/map_view/widgets/map_search_text_field.dart';
import 'package:immoplus/app/features/map_view/map_constantes.dart';
import 'package:immoplus/app/utils/app_colors.dart';

/// Style Google Maps immobilier premium
const _modernMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#f5f3ef"}]},
  {"elementType":"labels.icon","stylers":[{"visibility":"off"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#8a8580"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#f5f3ef"},{"weight":4}]},

  {"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#e0dbd5"},{"weight":1}]},
  {"featureType":"administrative.neighborhood","elementType":"labels.text.fill","stylers":[{"color":"#a09890"},{"weight":0.5}]},
  {"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},

  {"featureType":"landscape.man_made","elementType":"geometry.fill","stylers":[{"color":"#ede9e3"}]},
  {"featureType":"landscape.man_made","elementType":"geometry.stroke","stylers":[{"color":"#e0dbd5"},{"weight":0.5}]},
  {"featureType":"landscape.natural","elementType":"geometry.fill","stylers":[{"color":"#e8e4dc"}]},
  {"featureType":"landscape.natural.terrain","elementType":"geometry.fill","stylers":[{"color":"#dfd9d0"}]},

  {"featureType":"poi","stylers":[{"visibility":"off"}]},
  {"featureType":"poi.park","stylers":[{"visibility":"simplified"}]},
  {"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"color":"#d4ddc9"}]},
  {"featureType":"poi.park","elementType":"labels","stylers":[{"visibility":"off"}]},

  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},
  {"featureType":"road","elementType":"geometry.stroke","stylers":[{"visibility":"off"}]},
  {"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#b0a8a0"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#f0ece6"}]},
  {"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"visibility":"on"},{"color":"#e0dbd5"},{"weight":0.8}]},
  {"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#faf8f5"}]},
  {"featureType":"road.local","elementType":"geometry","stylers":[{"color":"#ffffff"}]},
  {"featureType":"road.local","elementType":"labels","stylers":[{"visibility":"off"}]},

  {"featureType":"transit","stylers":[{"visibility":"off"}]},

  {"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#c4dae5"}]},
  {"featureType":"water","elementType":"labels","stylers":[{"visibility":"off"}]}
]
''';

class MapViewer extends StatefulWidget {
  const MapViewer({super.key});
  static String name = "MAP_VIEWER";

  @override
  State<MapViewer> createState() => _MapViewerState();
}

class _MapViewerState extends State<MapViewer> with TickerProviderStateMixin {
  GoogleMapController? mapController;
  CameraPosition? _lastCameraPosition;
  late FocusNode focusNode;
  static const _defaultPosition = LatLng(5.365162, -4.000802);
  static const _startPosition = LatLng(9.0, 2.0);
  LatLng position = _defaultPosition;
  bool _flyInDone = false;
  bool _flyInInProgress = false;
  bool _searchExpanded = false;
  Timer? _autoReloadTimer;

  // ── Estimation card animations ──
  late AnimationController _estimationSlideController;
  late AnimationController _estimationFadeController;
  late Animation<Offset> _estimationSlideAnimation;
  late Animation<double> _estimationFadeAnimation;

  late AnimationController _countUpController;
  late Animation<double> _countUpAnimation;

  @override
  void initState() {
    super.initState();
    getIt<AnalyticsService>().logMapViewOpened();
    focusNode = FocusNode();

    _estimationSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _estimationSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _estimationSlideController,
      curve: const Cubic(0.34, 1.56, 0.64, 1),
    ));

    _estimationFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _estimationFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _estimationFadeController, curve: Curves.easeOut),
    );

    _countUpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _countUpAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _countUpController, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initUserPosition();
      if (!mounted) return;
      context.read<MapViwerCubit>().getMapDataAll(
            center: position,
            context: context,
            userPosition: position,
          );
    });
  }

  void _onPlaceSelected(LatLng pos) {
    _collapseSearch();
    mapController?.animateCamera(CameraUpdate.newLatLngZoom(pos, 14.0));
  }

  double zoomToRadiusKm(double zoom) => 40075 / (2 * pow(2, zoom - 1));

  Future<void> _fetchMapData(CameraPosition cameraPosition) async {
    final zoom = cameraPosition.zoom;
    final center = cameraPosition.target;
    final radius = zoomToRadiusKm(zoom);

    await context.read<MapViwerCubit>().getMapDataAll(
          context: context,
          center: center,
          radius: radius,
          zoom: zoom,
          perPage: 10,
          page: 1,
          userPosition: position,
        );
  }

  Future<void> _initUserPosition() async {
    try {
      final pos = await LocationService.getCurrentPosition();
      position = LatLng(pos.latitude, pos.longitude);
    } catch (_) {
      position = _defaultPosition;
    }
    await _flyInToPosition(position);
  }

  Future<void> _flyInToPosition(LatLng target) async {
    if (_flyInDone || mapController == null) return;
    _flyInDone = true;
    _flyInInProgress = true;

    await mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(const LatLng(7.54, -5.55), 7),
    );
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    await mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(target, 12),
    );
    _flyInInProgress = false;
  }

  void _onCameraIdle() {
    if (_flyInInProgress) return;
    _autoReloadTimer?.cancel();
    if (_lastCameraPosition == null) return;

    final cubit = context.read<MapViwerCubit>();
    final cam = _lastCameraPosition!;
    final radiusKm = zoomToRadiusKm(cam.zoom);
    final moveType = cubit.evaluateMove(cam.target, cam.zoom, radiusKm);

    switch (moveType) {
      case CameraMoveType.ignore:
        break;
      case CameraMoveType.showButton:
        cubit.requestShowButton();
        // Auto-reload silencieux après 3s d'immobilité
        _autoReloadTimer = Timer(const Duration(seconds: 3), () {
          if (!mounted || _lastCameraPosition == null) return;
          _fetchMapData(_lastCameraPosition!);
        });
        break;
      case CameraMoveType.autoReload:
        // Reload silencieux après 800ms
        _autoReloadTimer = Timer(const Duration(milliseconds: 800), () {
          if (!mounted || _lastCameraPosition == null) return;
          _fetchMapData(_lastCameraPosition!);
        });
        break;
    }
  }

  // ── Search ──
  void _expandSearch() {
    if (_searchExpanded) return;
    focusNode = FocusNode();
    setState(() => _searchExpanded = true);
    context.read<MapViwerCubit>().onChangeSearchFocus(true);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) focusNode.requestFocus();
    });
  }

  void _collapseSearch() {
    if (!_searchExpanded) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _searchExpanded = false);
    context.read<MapViwerCubit>().onChangeSearchFocus(false);
  }

  // ── Estimation card ──
  void _showEstimationCard() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (!mounted) return;
      _estimationSlideController.forward();
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      _estimationFadeController.forward();
      _countUpController.forward(from: 0);
    });
  }

  void _hideEstimationCard() {
    _estimationSlideController.reverse();
    _estimationFadeController.reverse();
    _countUpController.reset();
  }

  @override
  void dispose() {
    _autoReloadTimer?.cancel();
    _estimationSlideController.dispose();
    _estimationFadeController.dispose();
    _countUpController.dispose();
    MapCardOverlayService.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).viewPadding.top;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final mapStyle = isDark ? MapConstantes.darlStyle : _modernMapStyle;

    const estimationCardHeight = 72.0;

    return BlocListener<MapViwerCubit, MapViwerCubitState>(
      listenWhen: (prev, curr) => prev.showRoute != curr.showRoute,
      listener: (context, state) {
        if (state.showRoute) {
          _showEstimationCard();
        } else {
          _hideEstimationCard();
        }
      },
      child: Stack(
        children: [
          // ══════════════════════════════════════════════
          // ── MAP ──
          // ══════════════════════════════════════════════
          Positioned.fill(
            child: BlocSelector<MapViwerCubit, MapViwerCubitState,
                _MapDataSnapshot>(
              selector: (state) => _MapDataSnapshot(
                markers: state.markers ?? [],
                polygons: state.polygons ?? [],
                polylines: state.polyline ?? [],
              ),
              builder: (context, data) {
                return GoogleMap(
                  style: mapStyle,
                  initialCameraPosition: const CameraPosition(
                    target: _startPosition,
                    zoom: 3,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  mapType: MapType.hybrid,
                  buildingsEnabled: true,
                  markers: Set<Marker>.from(data.markers),
                  polygons: Set<Polygon>.from(data.polygons),
                  polylines: Set<Polyline>.from(data.polylines),
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    if (!_flyInDone) _flyInToPosition(position);
                  },
                  onTap: (_) {
                    if (_searchExpanded) {
                      _collapseSearch();
                    } else {
                      context.read<MapViwerCubit>().clearRoute();
                      MapCardOverlayService.hide();
                    }
                  },
                  onCameraMove: (CameraPosition pos) {
                    _lastCameraPosition = pos;
                  },
                  onCameraIdle: _onCameraIdle,
                );
              },
            ),
          ),

          // ── Dim overlay quand recherche active ──
          if (_searchExpanded)
            Positioned.fill(
              child: GestureDetector(
                onTap: _collapseSearch,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.4),
                ),
              ),
            ),

          // ── Permission banner ──
          Positioned(
            top: topPadding + 12,
            left: 20,
            right: 20,
            child: const LocationPermissionBanner(),
          ),

          // ══════════════════════════════════════════════
          // ── SEARCH BAR EN HAUT ──
          // ══════════════════════════════════════════════
          Positioned(
            top: topPadding + 14,
            left: 16,
            right: 16,
            child: _searchExpanded
                ? _buildExpandedSearch()
                : _buildCollapsedSearchBar(),
          ),

          // ── Bouton "Voir les biens ici" ──
          BlocSelector<MapViwerCubit, MapViwerCubitState, bool>(
            selector: (state) => state.showSearchButton,
            builder: (context, showButton) {
              if (!showButton || _searchExpanded) {
                return const SizedBox.shrink();
              }
              return Positioned(
                top: topPadding + 70,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      _autoReloadTimer?.cancel();
                      if (_lastCameraPosition != null) {
                        _fetchMapData(_lastCameraPosition!);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh_rounded,
                              size: 16, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Voir les biens ici',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // ── Boutons actions (zoom + recentrer) ──
          if (!_searchExpanded)
            Positioned(
              bottom: bottomPadding + 24,
              right: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMapButton(
                    icon: Icons.add_rounded,
                    onTap: () =>
                        mapController?.animateCamera(CameraUpdate.zoomIn()),
                  ),
                  const SizedBox(height: 10),
                  _buildMapButton(
                    icon: Icons.remove_rounded,
                    onTap: () =>
                        mapController?.animateCamera(CameraUpdate.zoomOut()),
                  ),
                  const SizedBox(height: 10),
                  _buildMapButton(
                    icon: Icons.my_location_rounded,
                    onTap: () async => _initUserPosition(),
                  ),
                ],
              ),
            ),

          // ══════════════════════════════════════════════
          // ── ESTIMATION CARD (bas) ──
          // ══════════════════════════════════════════════
          BlocSelector<MapViwerCubit, MapViwerCubitState, _SheetData>(
            selector: (state) => _SheetData(
              showRoute: state.showRoute,
              routeDistance: state.routeDistance,
              routeDuration: state.routeDuration,
            ),
            builder: (context, sheetData) {
              if (!sheetData.showRoute) return const SizedBox.shrink();
              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SlideTransition(
                  position: _estimationSlideAnimation,
                  child: _buildEstimationCard(
                      sheetData, bottomPadding, estimationCardHeight),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
    );
  }

  // ══════════════════════════════════════════════
  // ── SEARCH WIDGETS ──
  // ══════════════════════════════════════════════

  Widget _buildCollapsedSearchBar() {
    return GestureDetector(
      onTap: _expandSearch,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(Icons.search_rounded, size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(
              'Rechercher un lieu...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedSearch() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: PlaceAutocompleteWidget(
        focusNode: focusNode,
        onPlaceSelected: (p0) {
          _onPlaceSelected(p0);
        },
        googleApiKey: dotenv.get('GOOGLE_API_KEY'),
        onFocusChange: (isFocused) {
          if (!isFocused && _searchExpanded) {
            _collapseSearch();
          }
        },
      ),
    );
  }

  // ══════════════════════════════════════════════
  // ── ESTIMATION CARD ──
  // ══════════════════════════════════════════════

  Widget _buildEstimationCard(
      _SheetData data, double bottomPad, double cardHeight) {
    return FadeTransition(
      opacity: _estimationFadeAnimation,
      child: Container(
        height: cardHeight + bottomPad,
        padding: EdgeInsets.only(bottom: bottomPad),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedBuilder(
            animation: _countUpAnimation,
            builder: (context, _) {
              return Row(
                children: [
                  _buildEstimationBlock(
                    icon: Icons.navigation_rounded,
                    value: data.routeDistance ?? '--',
                    label: 'Distance',
                    animProgress: _countUpAnimation.value,
                  ),
                  const Spacer(),
                  Container(
                      width: 1, height: 36, color: const Color(0xFFF0F0F0)),
                  const Spacer(),
                  _buildEstimationBlock(
                    icon: Icons.access_time_rounded,
                    value: data.routeDuration ?? '--',
                    label: 'Temps estimé',
                    animProgress: _countUpAnimation.value,
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      context.read<MapViwerCubit>().clearRoute();
                      MapCardOverlayService.hide();
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close_rounded,
                          size: 16, color: Colors.grey.shade500),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEstimationBlock({
    required IconData icon,
    required String value,
    required String label,
    required double animProgress,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: animProgress,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── BlocSelector data classes ──

class _MapDataSnapshot {
  final List<Marker> markers;
  final List<Polygon> polygons;
  final List<Polyline> polylines;

  const _MapDataSnapshot({
    required this.markers,
    required this.polygons,
    required this.polylines,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _MapDataSnapshot &&
          markers.length == other.markers.length &&
          polygons.length == other.polygons.length &&
          polylines.length == other.polylines.length &&
          _listEquals(markers, other.markers) &&
          _listEquals(polygons, other.polygons) &&
          _listEquals(polylines, other.polylines);

  @override
  int get hashCode => Object.hash(
        Object.hashAll(markers),
        Object.hashAll(polygons),
        Object.hashAll(polylines),
      );

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class _SheetData {
  final bool showRoute;
  final String? routeDistance;
  final String? routeDuration;

  const _SheetData({
    required this.showRoute,
    this.routeDistance,
    this.routeDuration,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _SheetData &&
          showRoute == other.showRoute &&
          routeDistance == other.routeDistance &&
          routeDuration == other.routeDuration;

  @override
  int get hashCode => Object.hash(showRoute, routeDistance, routeDuration);
}
