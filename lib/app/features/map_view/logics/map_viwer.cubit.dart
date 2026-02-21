import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_collection.dart';
import 'package:immoplus/app/data/models/remote/residence/residences_collection.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/estate_detail/estate_page.dart';
import 'package:immoplus/app/features/map_view/logics/map_card_overlay_service.dart';
import 'package:immoplus/app/features/map_view/logics/map_marker_widget.dart';
import 'package:immoplus/app/features/map_view/logics/map_viwer_cubit_state.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/services/location_service.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/tickets_cards/small_estate_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/small_residence_card.dart';
import 'package:injectable/injectable.dart';

class _Constants {
  // ... constantes existantes ...

  // Guard déplacement caméra
  static const defaultPadding = 100.0;
  static const double radiusThresholdPercent = 0.2; // 20% du radius
  static const double defaultThresholdMeters = 500.0; // seuil si pas de radius
  static const double kmToMeters = 1000.0;
}

@injectable
class MapViwerCubit extends Cubit<MapViwerCubitState> {
  ResidenceRepository residenceRepository;
  BienImmobilierRepository bienImmobilierRepository;

  MapViwerCubit(this.residenceRepository, this.bienImmobilierRepository)
      : super(MapViwerCubitState());
  final Set<Marker> _markers = {};
  LatLng? _lastCenter;

  onChangeSearchFocus(bool focusState) {
    emit(state.copyWith(searchIsFocus: focusState));
  }

  Future<void> getMapDataAll({
    required LatLng center,
    double? radius,
    int? perPage,
    int? page,
    required BuildContext context,
  }) async {
    // ← Evite les appels redondants si la caméra n'a pas bougé significativement
    if (_lastCenter != null) {
      final distanceMeters = _distanceBetween(_lastCenter!, center);
      final thresholdMeters = radius != null
          ? (radius * _Constants.kmToMeters) * _Constants.radiusThresholdPercent
          : _Constants.defaultThresholdMeters;
      if (distanceMeters < thresholdMeters) return;
    }

    _lastCenter = center;

    emit(state.copyWith(isLoading: true));

    try {
      final results = await Future.wait([
        residenceRepository.getResidencesLocalized(
          lat: center.latitude,
          long: center.longitude,
          radius: radius,
          perPage: perPage,
          page: page,
        ),
        bienImmobilierRepository.getBiensLocalized(
          lat: center.latitude,
          long: center.longitude,
        ),
      ]);

      final residences = results[0] as ResidencesCollection;
      final biens = results[1] as BienImmobilierCollection;

      final residenceMarkers =
          await _buildResidencesMarkers(residences, context);
      final bienMarkers = await _buildBiensImmoMarkers(biens, context);

      _markers
        ..clear()
        ..addAll(residenceMarkers)
        ..addAll(bienMarkers);

      emit(state.copyWith(isLoading: false, markers: _markers.toList()));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  // Calcul simplifié de distance entre 2 LatLng (en mètres)
  double _distanceBetween(LatLng a, LatLng b) {
    const earthRadius = 6371000.0;
    final dLat = (b.latitude - a.latitude) * (pi / 180);
    final dLng = (b.longitude - a.longitude) * (pi / 180);
    final x = sin(dLat / 2) * sin(dLat / 2) +
        cos(a.latitude * (pi / 180)) *
            cos(b.latitude * (pi / 180)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    return earthRadius * 2 * atan2(sqrt(x), sqrt(1 - x));
  }

  Future<List<Marker>> _buildResidencesMarkers(
      ResidencesCollection residencesCollection, BuildContext context) async {
    final markers = await Future.wait(
      residencesCollection.data!.map((residence) async {
        final icon = await MapMarkerWidget.build(
          imageUrl: Utils.getImagePath(id: residence.miniature),
          price:
              "${CurrencyFormatter().format(residence.prixReservation.toString())} F",
          bgColor: AppColors.primary,
        );

        return Marker(
          markerId: MarkerId(residence.id),
          icon: icon,
          position: LatLng(
            residence.position.coordinates!.last,
            residence.position.coordinates!.first,
          ),
          onTap: () {
            MapCardOverlayService.show(
              context: context,
              bottomPadding: _Constants.defaultPadding,
              child: SmallResidenceCard(
                residenceModel: residence,
                closeTap: () => MapCardOverlayService.hide(),
                onCardTap: () {
                  MapCardOverlayService.hide();
                  context.push(ResidencePage.route(residence.id),
                      extra: residence);
                },
              ),
            );
          },
        );
      }),
    );

    return markers;
  }

  Future<List<Marker>> _buildBiensImmoMarkers(
      BienImmobilierCollection bienimmobilier, BuildContext context) async {
    final markers = await Future.wait(
      (bienimmobilier.data ?? []).map((bien) async {
        final icon = await MapMarkerWidget.build(
            imageUrl: Utils.getImagePath(id: bien.images.first),
            price: "${CurrencyFormatter().format(bien.prix.toString())} F",
            bgColor: AppColors.white,
            textColor: Colors.black);

        return Marker(
          icon: icon,
          markerId: MarkerId(bien.id),
          position: LatLng(
            bien.position.coordinates!.last,
            bien.position.coordinates!.first,
          ),
          onTap: () {
            MapCardOverlayService.show(
              context: NavigationService.navigatorKey.currentContext!,
              bottomPadding: _Constants.defaultPadding,
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
        );
      }),
    );

    return markers;
  }
}
