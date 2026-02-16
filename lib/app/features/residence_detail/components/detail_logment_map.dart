import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';
// import 'package:immoplus/app/utils/app_colors.dart';
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
    return (widget.residence.position != null)
        ? SliverPadding(
            padding: const EdgeInsets.all(8.0),
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
                          target: LatLng(
                            widget.residence.position.coordinates!.last,
                            widget.residence.position.coordinates!.first,
                          ),
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
                    )
                  ],
                ),
              ),
            ),
          )
        : const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
