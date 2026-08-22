import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/suggest/widgets/reverse_search_list_header.dart';
import 'package:immoplus/app/features/map_view/logics/map_marker_widget.dart';
import 'package:immoplus/app/data/models/remote/reverse_search/reverse_search_model.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/features/suggest/logic/reverse_search_cubit.dart';
import 'package:immoplus/app/features/suggest/logic/reverse_search_state.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:immoplus/app/widgets/recommande_badge.dart';
import 'package:immoplus/app/widgets/unified_property_card.dart';

class ReverseSearchMapPage extends StatefulWidget {
  static const String routeName = 'ReverseSearchMapPage';
  static const String routePath = '/reverse_search_map';

  final ReverseSearchRequest request;

  const ReverseSearchMapPage({super.key, required this.request});

  @override
  State<ReverseSearchMapPage> createState() => _ReverseSearchMapPageState();
}

class _ReverseSearchMapPageState extends State<ReverseSearchMapPage> {
  final ValueNotifier<Set<Marker>> _mapMarkersNotifier = ValueNotifier({});
  GoogleMapController? mapController;
  final ValueNotifier<bool> _showListNotifier = ValueNotifier(false);
  Timer? _timer;
  final ValueNotifier<int> _secondsNotifier = ValueNotifier<int>(0);
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  int _lastSocketPropsCount = -1;
  int _lastClassicPropsCount = -1;

  Future<void> _updateMarkers(
      String searchId,
      List<ReverseSearchProposition> socketProps,
      List<ResidenceModel> classicProps) async {
    if (socketProps.length == _lastSocketPropsCount &&
        classicProps.length == _lastClassicPropsCount) {
      return;
    }

    _lastSocketPropsCount = socketProps.length;
    _lastClassicPropsCount = classicProps.length;

    final Set<Marker> newMarkers = {};

    final socketFutures = socketProps
        .where((p) => p.data.position.coordinates?.isNotEmpty == true)
        .map((prop) async {
      final icon = await MapMarkerWidget.build(
        imageUrl: Utils.getImagePath(id: prop.data.miniature),
        price: "${CurrencyFormatter().format(prop.montant.toString())} F",
        bgColor: Colors.white,
        textColor: Colors.black,
      );
      return Marker(
        markerId: MarkerId('socket_${prop.data.id}'),
        position: LatLng(prop.data.position.coordinates!.last,
            prop.data.position.coordinates!.first),
        icon: icon,
        infoWindow: InfoWindow(
            title: prop.data.nom.isNotEmpty
                ? prop.data.nom
                : 'Libre tout de suite',
            snippet: '${prop.montant} FCFA'),
        onTap: () => _handleResidenceTap(
            searchId, prop.data, prop.montant.toDouble(), true),
      );
    });

    final classicFutures = classicProps
        .where((p) => p.position.coordinates?.isNotEmpty == true)
        .map((prop) async {
      final icon = await MapMarkerWidget.build(
        imageUrl: Utils.getImagePath(id: prop.miniature),
        price:
            "${CurrencyFormatter().format(prop.prixReservation.toString())} F",
        bgColor: AppColors.primary,
      );
      return Marker(
        markerId: MarkerId('classic_${prop.id}'),
        position: LatLng(
            prop.position.coordinates!.last, prop.position.coordinates!.first),
        icon: icon,
        infoWindow: InfoWindow(
            title: prop.nom.isNotEmpty ? prop.nom : 'Sur demande',
            snippet: '${prop.prixReservation} FCFA'),
        onTap: () => _handleResidenceTap(searchId, prop, null, false),
      );
    });

    final builtSocketMarkers = await Future.wait(socketFutures);
    final builtClassicMarkers = await Future.wait(classicFutures);

    newMarkers.addAll(builtSocketMarkers);
    newMarkers.addAll(builtClassicMarkers);

    if (mounted) {
      _mapMarkersNotifier.value = newMarkers;
    }
  }

  void _handleResidenceTap(String searchId, ResidenceModel residence,
      double? reverseSearchPrice, bool isImmediateBooking) {
    Constantes.tempPage = Utils.getCurrentLocation();
    context.push(ResidencePage.route(residence.id), extra: {
      'isImmediateBooking': isImmediateBooking,
      'reverseSearchId': searchId,
      'reverseSearchPrice': reverseSearchPrice,
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();

    _sheetController.addListener(() {
      if (_sheetController.size > 0.5 && !_showListNotifier.value) {
        _showListNotifier.value = true;
      } else if (_sheetController.size <= 0.5 && _showListNotifier.value) {
        _showListNotifier.value = false;
      }
    });

    final cubit = context.read<ReverseSearchCubit>();
    cubit.state.maybeWhen(
      searching: (searchId, socketProps, classicProps) {
        cubit.startListening(searchId, widget.request);
        _updateMarkers(searchId, socketProps, classicProps);
      },
      orElse: () {},
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _secondsNotifier.value++;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _secondsNotifier.dispose();
    _mapMarkersNotifier.dispose();
    _showListNotifier.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
  }

  Set<Circle> _buildCircles() {
    return widget.request.zones.map((zone) {
      return Circle(
        circleId: CircleId(zone.adresse),
        center: LatLng(zone.lat, zone.lng),
        radius: 2500, // 2.5km
        fillColor: AppColors.primary.withValues(alpha: 0.15),
        strokeColor: AppColors.primary.withValues(alpha: 0.4),
        strokeWidth: 1,
      );
    }).toSet();
  }

  void _showExitDialog(String searchId) {
    AppDialog.show(
      title: 'Recherche en cours',
      description:
          'Souhaitez-vous annuler la recherche lancée ou la conserver en arrière-plan ?',
      primaryButtonText: 'Conserver',
      secondButtonText: 'Annuler la recherche',
      onPrimary: () {
        context.goNamed(HomePage.name);
      },
      onSecond: () {
        if (searchId.isNotEmpty) {
          context.read<ReverseSearchCubit>().cancelSearch(searchId);
        }
        if (mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReverseSearchCubit, ReverseSearchState>(
      builder: (context, state) {
        int libres = 0;
        int confirmer = 0;
        List<ReverseSearchProposition> socketProps = [];
        List<ResidenceModel> classicProps = [];
        String currentSearchId = "";

        state.maybeWhen(
          searching: (id, props, classic) {
            currentSearchId = id;
            libres = props.length;
            confirmer = classic.length;
            socketProps = props;
            classicProps = classic;
          },
          orElse: () {},
        );

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _showExitDialog(currentSearchId);
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: BlocListener<ReverseSearchCubit, ReverseSearchState>(
              listener: (context, state) {
                state.maybeWhen(
                  searching: (searchId, socketProps, classicProps) {
                    _updateMarkers(searchId, socketProps, classicProps);
                  },
                  orElse: () {},
                );
              },
              child: Stack(
                children: [
                  // MAP
                  Positioned.fill(
                    child: ValueListenableBuilder<Set<Marker>>(
                      valueListenable: _mapMarkersNotifier,
                      builder: (context, markers, child) {
                        return GoogleMap(
                          key: const ValueKey('reverse_search_map'),
                          style: Constantes.modernMapStyle,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(widget.request.zones.first.lat,
                                widget.request.zones.first.lng),
                            zoom: 12,
                          ),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          mapToolbarEnabled: false,
                          circles: _buildCircles(),
                          markers: markers,
                          onMapCreated: (controller) {
                            mapController = controller;
                          },
                        );
                      },
                    ),
                  ),

                  // BOUTON RETOUR FLOTTANT
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => _showExitDialog(currentSearchId),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black87,
                          size: 18,
                        ),
                      ),
                    ),
                  ),

                  // BOTTOM SHEET
                  DraggableScrollableSheet(
                    controller: _sheetController,
                    initialChildSize: 0.35,
                    minChildSize: 0.35,
                    maxChildSize: 0.9,
                  snap: true,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, -4)),
                        ],
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            // Handle
                            Center(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(top: 12, bottom: 8),
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),

                            // Header Info
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Recherche en cours',
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 13)),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ValueListenableBuilder<int>(
                                        valueListenable: _secondsNotifier,
                                        builder: (context, seconds, child) {
                                          return Text(
                                            _formatTime(seconds),
                                            style: TextStyle(
                                                color: Colors.orange.shade800,
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold),
                                          );
                                        },
                                      ),
                                      Row(
                                        children: [
                                          Text('$libres Libres',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13)),
                                          const SizedBox(width: 8),
                                          Text('$confirmer Confirmer',
                                              style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontSize: 13)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Segmented Control & Cancel Button
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                _showListNotifier.value = false;
                                                _sheetController.animateTo(0.35,
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.easeInOut);
                                              },
                                              child:
                                                  ValueListenableBuilder<bool>(
                                                valueListenable:
                                                    _showListNotifier,
                                                builder: (context, show, _) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: !show
                                                          ? AppColors.primary
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              22),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'Carte',
                                                      style: TextStyle(
                                                        color: !show
                                                            ? Colors.white
                                                            : Colors.black87,
                                                        fontWeight: !show
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                _showListNotifier.value = true;
                                                _sheetController.animateTo(0.9,
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.easeInOut);
                                              },
                                              child:
                                                  ValueListenableBuilder<bool>(
                                                valueListenable:
                                                    _showListNotifier,
                                                builder: (context, show, _) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      color: show
                                                          ? AppColors.primary
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              22),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'Liste',
                                                      style: TextStyle(
                                                        color: show
                                                            ? Colors.white
                                                            : Colors.black87,
                                                        fontWeight: show
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () =>
                                          _showExitDialog(currentSearchId),
                                      child: Container(
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(22),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text('Annuler',
                                            style: TextStyle(
                                                color: Colors.black87)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // List View
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16),
                              child: Column(
                                children: [
                                  // LIBRE TOUT DE SUITE
                                  if (socketProps.isNotEmpty) ...[
                                    const ReverseSearchListHeader(
                                      title: 'Libre tout de suite',
                                      description:
                                          'Le propriétaire à confirmer vous payer c\'est reserve',
                                    ),
                                    const SizedBox(height: 16),
                                    ...socketProps.map(
                                      (prop) {
                                        final isImmediateBooking = true;
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: UnifiedPropertyCard(
                                            item: prop.data,
                                            badge: FreeReverseBadge(),
                                            onTap: () {
                                              inspect(prop);
                                              _handleResidenceTap(
                                                  currentSearchId,
                                                  prop.data,
                                                  prop.montant.toDouble(),
                                                  isImmediateBooking);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                  ],

                                  if (classicProps.isNotEmpty) ...[
                                    ReverseSearchListHeader(
                                      title: 'Sur demande',
                                      description:
                                          'Les ${classicProps.length} autres qui correspondent à votre besoin. Reponse du proprietaire sous 24h.',
                                    ),
                                    const SizedBox(height: 16),
                                    ...classicProps.map((prop) => Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: UnifiedPropertyCard(
                                            item: prop,
                                            onTap: () => _handleResidenceTap(
                                                currentSearchId,
                                                prop,
                                                null,
                                                false),
                                          ),
                                        )),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
