import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';

class DetailEstateMap extends StatefulWidget {
  const DetailEstateMap({super.key, required this.bienImmobilier});
  final BienImmobilierModel bienImmobilier;

  @override
  State<DetailEstateMap> createState() => _DetailEstateMapState();
}

class _DetailEstateMapState extends State<DetailEstateMap> {
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return (widget.bienImmobilier.position != null)
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
                        zoomGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            widget.bienImmobilier.position.coordinates!.last,
                            widget.bienImmobilier.position.coordinates!.first,
                          ),
                          zoom: 15.4,
                        ),
                        rotateGesturesEnabled: false,
                        tiltGesturesEnabled: false,
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
                            ),
                            Positioned(
                              left: 7,
                              top: 8,
                              child: CircleAvatar(
                                radius: 27,
                                backgroundImage: NetworkImage(
                                  Utils.getImagePath(
                                      id: widget.bienImmobilier.images.first),
                                ),
                              ),
                            ),
                          ],
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
