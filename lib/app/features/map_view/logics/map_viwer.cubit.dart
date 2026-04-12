import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
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
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/services/share_service.dart';
import 'package:immoplus/app/widgets/tickets_cards/small_estate_card.dart';
import 'package:immoplus/app/widgets/tickets_cards/small_residence_card.dart';
import 'package:injectable/injectable.dart';

class _Constants {
  static const defaultPadding = 140.0;
  static const double kmToMeters = 1000.0;
  static const double defaultRadiusKm = 5.0;
  static const int staggerDelayMs = 60;

  // Seuils de déplacement (en % du radius visible)
  static const double ignorePercent = 0.2;  // < 20% → rien
  static const double buttonPercent = 0.5;  // > 50% → bouton "Voir les biens ici"
}

/// Type de mouvement détecté sur la carte.
enum CameraMoveType { ignore, autoReload, showButton }

@injectable
class MapViwerCubit extends Cubit<MapViwerCubitState> {
  ResidenceRepository residenceRepository;
  BienImmobilierRepository bienImmobilierRepository;

  MapViwerCubit(this.residenceRepository, this.bienImmobilierRepository)
      : super(MapViwerCubitState());
  final Set<Marker> _markers = {};
  LatLng? _lastFetchedCenter;
  double? _lastFetchedZoom;
  int _staggerToken = 0;

  onChangeSearchFocus(bool focusState) {
    emit(state.copyWith(searchIsFocus: focusState));
  }

  /// Évalue le type de mouvement de la caméra.
  CameraMoveType evaluateMove(LatLng newCenter, double newZoom, double? radiusKm) {
    // Changement de zoom significatif → auto-reload silencieux
    if (_lastFetchedZoom != null && (newZoom - _lastFetchedZoom!).abs() > 1.0) {
      return CameraMoveType.autoReload;
    }

    if (_lastFetchedCenter == null) return CameraMoveType.autoReload;

    final distanceMeters = _distanceBetween(_lastFetchedCenter!, newCenter);
    final radiusMeters = (radiusKm ?? _Constants.defaultRadiusKm) * _Constants.kmToMeters;

    final movePercent = distanceMeters / radiusMeters;

    if (movePercent < _Constants.ignorePercent) return CameraMoveType.ignore;
    if (movePercent >= _Constants.buttonPercent) return CameraMoveType.showButton;
    return CameraMoveType.autoReload;
  }

  /// Affiche le bouton "Voir les biens ici".
  void requestShowButton() {
    emit(state.copyWith(showSearchButton: true));
  }

  /// Cache le bouton.
  void hideSearchButton() {
    emit(state.copyWith(showSearchButton: false));
  }

  /// Charge les données de la carte avec stagger animation.
  /// Les anciens markers restent visibles pendant le chargement.
  Future<void> getMapDataAll({
    required LatLng center,
    double? radius,
    double? zoom,
    int? perPage,
    int? page,
    required BuildContext context,
    LatLng? userPosition,
  }) async {
    _lastFetchedCenter = center;
    if (zoom != null) _lastFetchedZoom = zoom;

    emit(state.copyWith(isLoading: true, showSearchButton: false));

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

      final markerResults = await Future.wait([
        _buildResidencesMarkers(residences, context, userPosition),
        _buildBiensImmoMarkers(biens, context, userPosition),
      ]);

      final allNewMarkers = [...markerResults[0], ...markerResults[1]];

      // Stagger : émettre les markers un par un (anciens restent visibles)
      final token = ++_staggerToken;
      _markers.clear();
      emit(state.copyWith(
        isLoading: false,
        markerCount: allNewMarkers.length,
      ));

      for (int i = 0; i < allNewMarkers.length; i++) {
        if (_staggerToken != token) return;
        if (i > 0) {
          await Future.delayed(
              const Duration(milliseconds: _Constants.staggerDelayMs));
        }
        if (_staggerToken != token) return;
        _markers.add(allNewMarkers[i]);
        emit(state.copyWith(markers: _markers.toList()));
      }
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
      ResidencesCollection residencesCollection, BuildContext context, LatLng? userPosition) async {
    final markers = await Future.wait(
      (residencesCollection.data ?? []).map((residence) async {
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
            HapticFeedback.lightImpact();
            final markerPos = LatLng(
              residence.position.coordinates!.last,
              residence.position.coordinates!.first,
            );
            if (userPosition != null) {
              fetchRoute(origin: userPosition, destination: markerPos);
            }
            MapCardOverlayService.show(
              bottomPadding: _Constants.defaultPadding,
              child: SmallResidenceCard(
                residenceModel: residence,
                closeTap: () {
                  clearRoute();
                  MapCardOverlayService.hide();
                },
                onCardTap: () {
                  clearRoute();
                  MapCardOverlayService.hide();
                  NavigationService.navigatorKey.currentContext
                      ?.push(ResidencePage.route(residence.id), extra: residence);
                },
                onShareTap: () {
                  ShareService.shareResidence(
                    residenceId: residence.id,
                    residenceName: residence.nom,
                  );
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
      BienImmobilierCollection bienimmobilier, BuildContext context, LatLng? userPosition) async {
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
            HapticFeedback.lightImpact();
            final markerPos = LatLng(
              bien.position.coordinates!.last,
              bien.position.coordinates!.first,
            );
            if (userPosition != null) {
              fetchRoute(origin: userPosition, destination: markerPos);
            }
            MapCardOverlayService.show(
              bottomPadding: _Constants.defaultPadding,
              child: SmallEstateCard(
                  bienImmobilier: bien,
                  closeTap: () {
                    clearRoute();
                    MapCardOverlayService.hide();
                  },
                  onCardTap: () {
                    clearRoute();
                    MapCardOverlayService.hide();
                    Constantes.tempPage = Utils.getCurrentLocation();
                    NavigationService.navigatorKey.currentContext?.push(
                      EstatePage.route(bien.id),
                    );
                  },
                  onShareTap: () {
                    ShareService.shareBien(
                      bienId: bien.id,
                      bienName: bien.nom,
                    );
                  }),
            );
          },
        );
      }),
    );

    return markers;
  }

  // ── Itinéraire ──

  /// Trace la route entre la position utilisateur et la destination.
  Future<void> fetchRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final apiKey = dotenv.get('GOOGLE_API_KEY');
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&mode=driving'
        '&key=$apiKey',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 8));
      final data = json.decode(response.body);

      if (data['status'] != 'OK' ||
          (data['routes'] as List).isEmpty) {
        return;
      }

      final route = data['routes'][0];
      final leg = route['legs'][0];
      final distance = leg['distance']['text'] as String;
      final duration = leg['duration']['text'] as String;
      final encodedPolyline =
          route['overview_polyline']['points'] as String;

      // Décoder le polyline
      final decoded = PolylinePoints.decodePolyline(encodedPolyline);
      final routeCoords = decoded
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();

      final routePolyline = Polyline(
        polylineId: const PolylineId('route'),
        points: routeCoords,
        color: AppColors.primary,
        width: 5,
        patterns: [],
      );

      emit(state.copyWith(
        polyline: [routePolyline],
        showRoute: true,
        routeDistance: distance,
        routeDuration: duration,
      ));
    } catch (_) {
      // Silencieux — pas de route affichée en cas d'erreur
    }
  }

  /// Efface l'itinéraire affiché.
  void clearRoute() {
    emit(state.copyWith(
      polyline: [],
      showRoute: false,
      clearRoute: true,
    ));
  }
}
