import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';
import 'package:immoplus/app/widgets/fullscreen_location_map.dart';

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
    final coordinates = widget.bienImmobilier.position?.coordinates;
    if (coordinates == null || coordinates.length < 2) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    final position = LatLng(coordinates.last, coordinates.first);

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
                          target: position,
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
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => FullscreenLocationMap.show(
                            context,
                            position: position,
                            title: widget.bienImmobilier.nom,
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
