import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_collection.dart';
import 'package:immoplus/app/data/models/remote/residence/residences_collection.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/estate_detail/estate_page.dart';
import 'package:immoplus/app/features/map_view/logics/map_card_overlay_service.dart';
import 'package:immoplus/app/features/map_view/logics/map_viwer_cubit_state.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/tickets_cards/small_estate_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/small_residence_card.dart';
import 'package:injectable/injectable.dart';

const _defaultPadding = 100.0;

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
      {required LatLng center,
      double? radius,
      int? perPage,
      int? page,
      required BuildContext context}) async {
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
    datas.addAll(await _buildResidencesMarkers(residencesCollection, context));
    datas.addAll(
        await _buildBiensImmoMarkers(bienImmobilierCollection, context));

    emit(MapViwerCubitState(markers: datas));
  }

  Future<List<Marker>> _buildResidencesMarkers(
      ResidencesCollection residencesCollection, BuildContext context) async {
    List<Marker> list = [];

    for (var residence in residencesCollection.data!) {
      list.add(await GoogleMapsCustomMarker.createCustomMarker(
        marker: Marker(
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId(residence.id),
          position: LatLng(
            residence.position.coordinates!.last,
            residence.position.coordinates!.first,
          ),
          onTap: () {
            // final context = NavigationService.navigatorKey.currentContext!;
            MapCardOverlayService.show(
              context: context,
              bottomPadding: _defaultPadding,
              child: SmallResidenceCard(
                residenceModel: residence,
                closeTap: () {
                  MapCardOverlayService.hide();
                },
                onCardTap: () {
                  MapCardOverlayService.hide();
                  context.push(
                    ResidencePage.route(residence.id),
                    extra: residence,
                  );
                },
              ),
            );
            // showModalBottomSheet(
            //     context: NavigationService.navigatorKey.currentContext!,
            //     backgroundColor: Colors.transparent,
            //     barrierColor: Colors.transparent,
            //     isDismissible: true,
            //     isScrollControlled: true,
            //     useRootNavigator: true,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //     //showDragHandle: true,
            //     enableDrag: true,
            //     builder: (context) => Container(
            //           height: 150,
            //           //padding: const EdgeInsets.all(10),
            //           margin: EdgeInsets.only(
            //               bottom: MediaQuery.of(context).viewPadding.bottom +
            //                   _defaultPadding,
            //               left: 10,
            //               right: 10),
            //           decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(30),
            //             boxShadow: const [
            //               BoxShadow(
            //                 color: Colors.black26,
            //                 blurRadius: 10,
            //                 offset: Offset(0, -5),
            //               ),
            //             ],
            //           ),
            //           child: SmallResidenceCard(
            //             residenceModel: element,
            //             closeTap: () {
            //               Navigator.pop(context);
            //             },
            //           ),
            //         ));
          },
        ),
        shape: MarkerShape.bubble,
        title:
            "${CurrencyFormatter().format(residence.prixReservation.toString())}F /nuit",
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
      BienImmobilierCollection bienimmobilier, BuildContext context) async {
    List<Marker> list = [];

    for (var bien in bienimmobilier.data!) {
      list.add(await GoogleMapsCustomMarker.createCustomMarker(
        marker: Marker(
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId(bien.id),
          position: LatLng(
            bien.position.coordinates!.last,
            bien.position.coordinates!.first,
          ),
          onTap: () {
            // final context = NavigationService.navigatorKey.currentContext!;
            MapCardOverlayService.show(
              context: NavigationService.navigatorKey.currentContext!,
              bottomPadding: _defaultPadding,
              child: SmallEstateCard(
                  bienImmobilier: bien,
                  closeTap: () {
                    MapCardOverlayService.hide();
                  },
                  onCardTap: () {
                    MapCardOverlayService.hide();
                    Constantes.tempPage = Utils.getCurrentLocation();
                    context.push(
                      EstatePage.route(bien.id),
                    );
                  }),
            );
          },
        ),
        shape: MarkerShape.bubble,
        title:
            "${CurrencyFormatter().format(bien.prix.toString())}F /${bien.typeLocation}",
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
