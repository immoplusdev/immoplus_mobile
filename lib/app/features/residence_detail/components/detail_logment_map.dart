import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:map_launcher/map_launcher.dart' as MPL;

class DetailLogmentMap extends StatefulWidget {
  const DetailLogmentMap({super.key, required this.residence});
  final ResidenceModel residence;

  @override
  State<DetailLogmentMap> createState() => _DetailLogmentMapState();
}

class _DetailLogmentMapState extends State<DetailLogmentMap> {
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
          widget.residence.position.coordinates.last,
          widget.residence.position.coordinates.first,
        ),
        onTap: () async {
          if (await MPL.MapLauncher.isMapAvailable(MPL.MapType.google) ??
              false) {
            MPL.MapLauncher.showDirections(
              destinationTitle: widget.residence.nom,
              destination: MPL.Coords(
                widget.residence.position.coordinates[1],
                widget.residence.position.coordinates[0],
              ),
              directionsMode: MPL.DirectionsMode.driving,
              mapType: MPL.MapType.google,
            );
          } else {
            final availableMaps = await MPL.MapLauncher.installedMaps;
            print(availableMaps);
            await availableMaps.first.showDirections(
              destinationTitle: widget.residence.nom,
              destination: MPL.Coords(
                widget.residence.position.coordinates[1],
                widget.residence.position.coordinates[0],
              ),
              directionsMode: MPL.DirectionsMode.driving,
            );
          }
        },
      ),
      shape: MarkerShape.bubble,
      imagePixelRatio: 2,
      title: widget.residence.nom ?? 'Résidence',
      textSize: 35,
      backgroundColor: AppColors.primary,
    );

    setState(() {
      _markers.add(customMarker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return (widget.residence.position != null)
        ? SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: GoogleMap(
                mapType: MapType.normal,
                markers: _markers,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.residence.position.coordinates.last,
                    widget.residence.position.coordinates.first,
                  ),
                  zoom: 15.4,
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
