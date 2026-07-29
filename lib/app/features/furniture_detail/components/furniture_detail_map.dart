import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/utils/utils.dart';

class FurnitureDetailMap extends StatefulWidget {
  const FurnitureDetailMap({super.key, required this.furniture});
  final FurnitureModel furniture;

  @override
  State<FurnitureDetailMap> createState() => _FurnitureDetailMapState();
}

class _FurnitureDetailMapState extends State<FurnitureDetailMap> {
  @override
  Widget build(BuildContext context) {
    final coordinates = widget.furniture.position.coordinates;
    final hasValidCoordinates = coordinates != null && coordinates.length >= 2;

    if (!hasValidCoordinates) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final lat = coordinates.last;
    final lng = coordinates.first;
    final hasImage = widget.furniture.images.isNotEmpty;

    return SliverPadding(
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
                  zoomGesturesEnabled: false,
                  scrollGesturesEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, lng),
                    zoom: 15.4,
                  ),
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  myLocationButtonEnabled: false,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/icons/markers.svg',
                        height: 100,
                      ),
                      Positioned(
                        left: 7,
                        top: 8,
                        child: CircleAvatar(
                          radius: 27,
                          backgroundImage: hasImage
                              ? NetworkImage(
                                  Utils.getImagePath(
                                    id: widget.furniture.images.first,
                                  ),
                                )
                              : null,
                          child: hasImage ? null : const Icon(Icons.chair_alt),
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
    );
  }
}
