import 'dart:math';
import 'dart:ui';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:immoplus/app/features/map_view/logics/map_card_overlay_service.dart';
import 'package:immoplus/app/features/map_view/logics/map_viwer.cubit.dart';
import 'package:immoplus/app/features/map_view/logics/map_viwer_cubit_state.dart';
import 'package:immoplus/app/services/location_service.dart';
import 'package:immoplus/app/widgets/map/location_permission_banner.dart';
import 'package:immoplus/app/features/map_view/widgets/map_search_text_field.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:loading_indicator/loading_indicator.dart';

class MapViewer extends StatefulWidget {
  const MapViewer({super.key});
  static String name = "MAP_VIEWER";

  @override
  State<MapViewer> createState() => _MapViewerState();
}

class _MapViewerState extends State<MapViewer> {
  GoogleMapController? mapController;
  FocusNode focusNode = FocusNode();
  static const _defaultPosition = LatLng(5.365162, -4.000802);
  LatLng position = _defaultPosition;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initUserPosition();
      context
          .read<MapViwerCubit>()
          .getMapDataAll(center: position!, context: context);
    });

    super.initState();
  }

  void _onPlaceSelected(LatLng position) {
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(position, 14.0),
    );
    // Vous pouvez également ajouter un marqueur ici si nécessaire
  }

  double zoomToRadiusKm(double zoom) {
    // Tu peux affiner la formule selon ton besoin
    return 40075 / (2 * pow(2, zoom - 1));
  }

  int getPerPage(double zoom) {
    return 10;
    if (zoom < 5) {
      return 20; // continent
    } else if (zoom < 10) {
      return 50; // pays
    } else if (zoom < 14) {
      return 1000; // ville
    } else {
      return 300; // quartier
    }
  }

  Future<void> fetchMapData(CameraPosition cameraPosition) async {
    final zoom = cameraPosition.zoom;
    final center = cameraPosition.target;
    final radius = zoomToRadiusKm(zoom);
    final perPage = getPerPage(zoom);

    await context.read<MapViwerCubit>().getMapDataAll(
          context: context,
          center: center,
          radius: radius,
          perPage: perPage,
          page: 1, // tu peux gérer le paging plus tard
        );
  }

  Future<void> _initUserPosition() async {
    try {
      final pos = await LocationService.getCurrentPosition();
      position = LatLng(pos.latitude, pos.longitude);
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(position, 13),
      );
    } catch (_) {
      position = LatLng(5.365162, -4.000802);
    }
  }

  @override
  void dispose() {
    MapCardOverlayService.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapViwerCubit, MapViwerCubitState>(
      builder: (context, state) {
        return Stack(
          children: [
            GoogleMap(
              style:
                  '[{"featureType": "poi","elementType": "labels","stylers": [{"visibility": "off"}]}]',
              initialCameraPosition: CameraPosition(
                target: position,
                zoom: state.zoom,
              ),
              myLocationEnabled: true,
              mapType: MapType.normal,
              markers: Set<Marker>.from(state.markers ?? []),
              polygons: Set<Polygon>.from(state.polygons ?? []),
              polylines: Set<Polyline>.from(state.polyline ?? []),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              onTap: (LatLng point) {
                print(point);
              },
              //   onCameraMove: (CameraPosition cameraPosition) {
              //     EasyDebounce.debounce(
              //       'map_bouncer',
              //       const Duration(milliseconds: 300),
              //       () {
              //         context
              //             .read<MapViwerCubit>()
              //             .getMapDataAll(center: cameraPosition.target);
              //       },
              //     );
              //   },
              // ),
              onCameraMove: (CameraPosition cameraPosition) {
                EasyDebounce.debounce(
                  'map_bouncer',
                  const Duration(milliseconds: 300),
                  () {
                    fetchMapData(cameraPosition);
                  },
                );
              },
            ),
            Visibility(
              visible: state.searchIsFocus,
              child: GestureDetector(
                onTap: _dismissSearch,
                onPanUpdate: (_) => _dismissSearch(),
                onPanStart: (_) => _dismissSearch(),
                onPanEnd: (_) => _dismissSearch(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: 4.0, sigmaY: 4.0), // Intensité du flou
                  child: Container(
                    color: Colors
                        .transparent, // Pour que l'image derrière soit visible avec flou
                  ),
                ),
              ),
            ),
            Positioned(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25)
                    .copyWith(top: 80),
                child: Column(
                  children: [
                    PlaceAutocompleteWidget(
                      focusNode: focusNode,
                      onPlaceSelected: (p0) {
                        _dismissSearch();
                        _onPlaceSelected(p0);
                      },
                      googleApiKey: dotenv.get('GOOGLE_API_KEY'),
                      onFocusChange: (isFocused) {
                        if (!isFocused) {
                          _dismissSearch();
                        } else {
                          context
                              .read<MapViwerCubit>()
                              .onChangeSearchFocus(true);
                        }
                      },
                    ),
                    LocationPermissionBanner(),
                  ],
                ),
              ),
            ),
            if (state.isLoading)
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 30,
                    width: 80,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 3, spreadRadius: 1, color: Colors.grey),
                      ],
                    ),
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballBeat,
                      colors: [
                        Colors.blue,
                        AppColors.primary,
                        Colors.blue.shade100,
                      ],
                      strokeWidth: 3,
                      backgroundColor: Colors.white,
                      pathBackgroundColor: Colors.black,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _dismissSearch() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        FocusManager.instance.primaryFocus?.unfocus();
        context.read<MapViwerCubit>().onChangeSearchFocus(false);
      } catch (_) {}
    });
  }
}
