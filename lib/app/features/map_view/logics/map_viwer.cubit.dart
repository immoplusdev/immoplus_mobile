import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_collection.dart';
import 'package:immoplus/app/data/models/remote/residence/residences_collection.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/map_view/logics/map_viwer_cubit_state.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/widgets/tickets_cards/small_estate_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/small_residence_card.dart';
import 'package:injectable/injectable.dart';

@injectable
class MapViwerCubit extends Cubit<MapViwerCubitState> {
  ResidenceRepository residenceRepository;
  BienImmobilierRepository bienImmobilierRepository;

  MapViwerCubit(this.residenceRepository, this.bienImmobilierRepository)
      : super(MapViwerCubitState());
  static List<Marker> datas = [];

  onChangeSearchFocus(bool focusState) {
    emit(MapViwerCubitState(searchIsFocus: focusState, markers: datas));
  }

  getMapDataAll(
      {required LatLng center, double? radius, int? perPage, int? page}) async {
    emit(MapViwerCubitState(isLoading: true, markers: datas));

    ResidencesCollection residencesCollection =
        await residenceRepository.getResidencesLocalized(
      lat: center.latitude,
      long: center.longitude,
      radius: radius,
      perPage: perPage,
      page: page,
    );
    BienImmobilierCollection bienImmobilierCollection =
        await bienImmobilierRepository.getBiensLocalized(
            lat: center.latitude, long: center.longitude);
    datas.clear();
    datas.addAll(await _buildResidencesMarkers(residencesCollection));
    datas.addAll(await _buildBiensImmoMarkers(bienImmobilierCollection));

    emit(MapViwerCubitState(markers: datas));
  }

  Future<List<Marker>> _buildResidencesMarkers(
      ResidencesCollection residencesCollection) async {
    List<Marker> list = [];

    for (var element in residencesCollection.data!) {
      list.add(await GoogleMapsCustomMarker.createCustomMarker(
        marker: Marker(
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId(element.id),
          position: LatLng(
            element.position.coordinates!.last,
            element.position.coordinates!.first,
          ),
          onTap: () {
            showModalBottomSheet(
                context: NavigationService.navigatorKey.currentContext!,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.transparent,
                isScrollControlled: true,
                useRootNavigator: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                //showDragHandle: true,
                enableDrag: true,
                builder: (context) => Container(
                      height: 150,
                      //padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(
                          bottom: 40, left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SmallResidenceCard(residenceModel: element),
                    ));
          },
        ),
        shape: MarkerShape.bubble,
        title:
            "${CurrencyFormatter().format(element.prixReservation.toString())}F /nuit",
        backgroundColor: AppColors.primary,
        textSize: 40,
        imagePixelRatio: 3.0,
        foregroundColor: Colors.white,
        textStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ));
    }

    return list;
  }

  Future<List<Marker>> _buildBiensImmoMarkers(
      BienImmobilierCollection bienimmobilier) async {
    List<Marker> list = [];

    for (var element in bienimmobilier.data!) {
      list.add(await GoogleMapsCustomMarker.createCustomMarker(
        marker: Marker(
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId(element.id),
          position: LatLng(
            element.position.coordinates!.last,
            element.position.coordinates!.first,
          ),
          onTap: () {
            showModalBottomSheet(
                context: NavigationService.navigatorKey.currentContext!,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.transparent,
                isScrollControlled: true,
                useRootNavigator: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                //showDragHandle: true,
                enableDrag: true,
                builder: (context) => Container(
                      height: 150,
                      //padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(
                          bottom: 40, left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SmallEstateCard(bienImmobilier: element),
                    ));
          },
        ),
        shape: MarkerShape.bubble,
        title:
            "${CurrencyFormatter().format(element.prix.toString())}F /${element.typeLocation}",
        backgroundColor: Colors.purple,
        textSize: 40,
        imagePixelRatio: 3.0,
        foregroundColor: Colors.white,
        textStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ));
    }

    return list;
  }
}
