import 'package:flutter/material.dart';
import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:map_launcher/map_launcher.dart' as MPL;

class DetailEstateMap extends StatefulWidget {
  const DetailEstateMap({super.key, required this.bienImmobilier});
  final BienImmobilierModel bienImmobilier;
  @override
  State<DetailEstateMap> createState() => _DetailEstateMapState();
}

class _DetailEstateMapState extends State<DetailEstateMap> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _addCustomMarker();
  }

  Future<void> _addCustomMarker() async {
    Marker customMarker = await GoogleMapsCustomMarker.createCustomMarker(
      marker: Marker(
        markerId: const MarkerId('residenceMarker'),
        position: LatLng(
          widget.bienImmobilier.position.coordinates!.last,
          widget.bienImmobilier.position.coordinates!.first,
        ),
        onTap: () async {
          if (await MPL.MapLauncher.isMapAvailable(MPL.MapType.google) ??
              false) {
            MPL.MapLauncher.showDirections(
              destinationTitle: widget.bienImmobilier.nom,
              destination: MPL.Coords(
                widget.bienImmobilier.position.coordinates![1],
                widget.bienImmobilier.position.coordinates![0],
              ),
              directionsMode: MPL.DirectionsMode.driving,
              mapType: MPL.MapType.google,
            );
          } else {
            final availableMaps = await MPL.MapLauncher.installedMaps;

            await availableMaps.first.showDirections(
              destinationTitle: widget.bienImmobilier.nom,
              destination: MPL.Coords(
                widget.bienImmobilier.position.coordinates![1],
                widget.bienImmobilier.position.coordinates![0],
              ),
              directionsMode: MPL.DirectionsMode.driving,
            );
          }
        },
      ),
      shape: MarkerShape.bubble,
      imagePixelRatio: 2,
      title: widget.bienImmobilier.nom ?? 'Résidence',
      textSize: 35,
      backgroundColor: AppColors.primary,
    );

    setState(() {
      _markers.add(customMarker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return (widget.bienImmobilier.position != null)
        ? SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: GoogleMap(
                mapType: MapType.normal,
                markers: _markers,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.bienImmobilier.position.coordinates!.last,
                    widget.bienImmobilier.position.coordinates!.first,
                  ),
                  zoom: 12.4,
                ),
                rotateGesturesEnabled: false, // Désactive la rotation
                tiltGesturesEnabled:
                    false, // Désactive les gestes d'inclinaison
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
              ),
            ),
          )
        : const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
