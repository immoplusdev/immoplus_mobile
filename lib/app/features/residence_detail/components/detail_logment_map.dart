import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
// import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';
import 'package:immoplus/app/widgets/fullscreen_location_map.dart';
// import 'package:immoplus/app/design_system/design_system.dart';
// import 'package:map_launcher/map_launcher.dart' as MPL;

class DetailLogmentMap extends StatefulWidget {
  const DetailLogmentMap({super.key, required this.residence});
  final ResidenceModel residence;

  @override
  State<DetailLogmentMap> createState() => _DetailLogmentMapState();
}

class _DetailLogmentMapState extends State<DetailLogmentMap> {
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final coordinates = widget.residence.position?.coordinates;
    if (coordinates == null || coordinates.length < 2) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    final position = LatLng(coordinates.last, coordinates.first);

    return (widget.residence.position != null)
        ? SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: appPadding, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        // markers: _markers,
                        zoomGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: position,
                          zoom: 15.4,
                        ),
                        rotateGesturesEnabled: false, // Désactive la rotation
                        tiltGesturesEnabled:
                            false, // Désactive les gestes d'inclinaison
                        myLocationButtonEnabled: false,
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                        },
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              "assets/svgs/icons/markers.svg",
                              height: 100,
                              // height: 50,
                              // width: 50,
                            ),
                            Positioned(
                              left: 7,
                              top: 8,
                              child: CircleAvatar(
                                radius: 27,
                                backgroundImage: NetworkImage(
                                    Utils.getImagePath(
                                        id: widget.residence.images.first)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => FullscreenLocationMap.show(
                            context,
                            position: position,
                            title: widget.residence.nom,
                          ),
                          child: const Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.all(14),
                              child: _MapExpandLabel(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}

class _MapExpandLabel extends StatelessWidget {
  const _MapExpandLabel();

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.fullscreen, size: 18),
              SizedBox(width: 6),
              Text('Agrandir'),
            ],
          ),
        ),
      );
}
