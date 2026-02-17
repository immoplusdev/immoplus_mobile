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
  @override
  void initState() {
    context
        .read<MapViwerCubit>()
        .getMapDataAll(center: LatLng(5.365162, -4.000802), context: context);
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
          radius: radius * 1000, // Convertir km en mètres
          perPage: perPage,
          page: 1, // tu peux gérer le paging plus tard
        );
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
                target: state.initialPosition,
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
                // Détecte un simple tap
                onTap: () {
                  context.read<MapViwerCubit>().onChangeSearchFocus(false);
                  focusNode.unfocus();
                },

                // Détecte un mouvement (glissement ou déplacement)
                onPanUpdate: (details) {
                  context.read<MapViwerCubit>().onChangeSearchFocus(false);
                  focusNode.unfocus();
                },

                // Détecte le début du mouvement
                onPanStart: (details) {
                  context.read<MapViwerCubit>().onChangeSearchFocus(false);
                  focusNode.unfocus();
                },

                // Détecte la fin du mouvement
                onPanEnd: (details) {
                  context.read<MapViwerCubit>().onChangeSearchFocus(false);
                  focusNode.unfocus();
                },
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
                      onPlaceSelected: (p0) => _onPlaceSelected(p0),
                      googleApiKey: dotenv.get('GOOGLE_API_KEY'),
                      onFocusChange: (isFocused) {
                        // if (isFocused = true) {
                        //   Future.delayed(const Duration(microseconds: 500), () {
                        //     focusNode.requestFocus();
                        //   });
                        // }
                        context
                            .read<MapViwerCubit>()
                            .onChangeSearchFocus(isFocused);

                        // if (isFocused) {
                        //   print('Le champ a le focus');
                        // } else {
                        //   print('Le champ a perdu le focus');
                        // }
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
}
