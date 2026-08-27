import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/suggest/widgets/reverse_search_list_header.dart';
import 'package:immoplus/app/features/suggest/widgets/reverse_search_waiting_banner.dart';
import 'package:immoplus/app/features/map_view/logics/map_marker_widget.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/services/reverse_search_socket_service.dart';
import 'package:immoplus/app/data/enums/reverse_search_status.dart';
import 'package:immoplus/app/data/models/remote/reverse_search/reverse_search_model.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/repositories/reverse_search_repository.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/features/suggest/logic/reverse_search_cubit.dart';
import 'package:immoplus/app/features/suggest/logic/reverse_search_state.dart';
import 'package:immoplus/app/features/suggest/widgets/pending_selection_card.dart';
import 'package:immoplus/app/features/suggest/widgets/selection_countdown.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
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
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  // Expiration de la recherche elle-même (distincte de `selectionExpireAt`).
  DateTime? _expiresAt;
  DateTime? _createdAt;
  bool _isExpired = false;

  StreamSubscription? _expiredSub;
  StreamSubscription? _expirationImminenteSub;

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
        price:
            "${CurrencyFormatter().format(prop.montantTotal.round().toString())} F",
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
            snippet: '${prop.montantTotal.round()} FCFA'),
        onTap: () =>
            _handleResidenceTap(searchId, prop.data, prop.montantTotal, true),
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
      'reverseSearchNights':
          residence.reverseSearchNombreNuits ?? widget.request.nights,
      'reverseSearchPrixParNuit': residence.reverseSearchPrixParNuit,
    }).then((_) => _refreshLockStateFromServer(searchId));
  }

  /// Revérifie l'état réel de la sélection au retour (verrou pas géré par ce cubit).
  Future<void> _refreshLockStateFromServer(String searchId) async {
    if (!mounted) return;
    try {
      final detailed =
          await getIt<ReverseSearchRepository>().getReverseSearchById(searchId);
      if (!mounted || detailed == null) return;
      context.read<ReverseSearchCubit>().resumeSearch(
            detailed.id,
            widget.request,
            propositions: detailed.propositionsList,
            pendingSelection: detailed.pendingSelectionProposition,
            selectionExpireAt: detailed.selectionExpireAt,
          );
      _applyExpiry(detailed);
    } catch (_) {}
  }

  Future<void> _loadExpiry(String searchId) async {
    try {
      final detailed =
          await getIt<ReverseSearchRepository>().getReverseSearchById(searchId);
      if (!mounted || detailed == null) return;
      _applyExpiry(detailed);
    } catch (_) {}
  }

  void _applyExpiry(ReverseSearchItem detailed) {
    if (!mounted) return;
    final wasExpired = _isExpired;
    setState(() {
      _expiresAt = detailed.expiresAt;
      _createdAt = detailed.createdAt;
      _isExpired = detailed.statusEnum == ReverseSearchStatus.expiree ||
          (detailed.expiresAt?.isBefore(DateTime.now()) ?? false);
    });
    if (_isExpired && !wasExpired) _showExpiredDialog(detailed.id);
  }

  /// Écoute les events temps réel d'expiration de la recherche.
  void _listenToSocketUpdates(String searchId) {
    final socketService = getIt<ReverseSearchSocketService>();

    _expiredSub?.cancel();
    _expiredSub = socketService.onStatus.listen((status) {
      if (!mounted || status != 'expiree' || _isExpired) return;
      setState(() => _isExpired = true);
      _showExpiredDialog(searchId);
    });

    _expirationImminenteSub?.cancel();
    _expirationImminenteSub =
        socketService.onExpirationImminente.listen((event) {
      if (!mounted || event.reverseSearchId != searchId) return;
      final minutes = event.minutesRestantes;
      ToastUtils.showWarning(
        title: 'Recherche bientôt expirée',
        description: minutes > 1
            ? 'Plus que $minutes minutes avant l\'expiration de votre recherche.'
            : 'Plus qu\'une minute avant l\'expiration de votre recherche.',
      );
    });
  }

  Widget _buildLibresEnAttenteRow(int libres, int enAttente) {
    return Row(
      children: [
        Text('$libres Libres',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(width: 8),
        Text('$enAttente En attente',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
      ],
    );
  }

  /// Prévient l'utilisateur de l'expiration puis le ramène au formulaire.
  void _showExpiredDialog(String searchId) {
    AppDialog.show(
      title: 'Recherche expirée',
      description:
          'Le délai de votre recherche est écoulé. Vous pouvez lancer une nouvelle recherche.',
      primaryButtonText: 'Nouvelle recherche',
      barrierDismissible: false,
      onPrimary: () async {
        // Annule explicitement côté serveur pour éviter que la page précédente ne reprenne cette recherche comme "active".
        if (searchId.isNotEmpty) {
          await context.read<ReverseSearchCubit>().cancelSearch(searchId);
        }
        if (mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _sheetController.addListener(() {
      if (_sheetController.size > 0.5 && !_showListNotifier.value) {
        _showListNotifier.value = true;
      } else if (_sheetController.size <= 0.5 && _showListNotifier.value) {
        _showListNotifier.value = false;
      }
    });

    final cubit = context.read<ReverseSearchCubit>();
    cubit.state.maybeWhen(
      searching: (searchId, socketProps, classicProps, _, __) {
        cubit.startListening(searchId, widget.request);
        _updateMarkers(searchId, socketProps, classicProps);
        _loadExpiry(searchId);
        _listenToSocketUpdates(searchId);
      },
      orElse: () {},
    );
  }

  @override
  void dispose() {
    _expiredSub?.cancel();
    _expirationImminenteSub?.cancel();
    _mapMarkersNotifier.dispose();
    _showListNotifier.dispose();
    _sheetController.dispose();
    super.dispose();
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

  void _continueToPayment(
    BuildContext context,
    String searchId,
    ReverseSearchProposition proposition,
  ) {
    context
        .pushNamed(
          OperatorsSelectorPage.name,
          extra: PaymentPageAdapter(
            itemId: searchId,
            collection: ProductType.reverse_searches.name,
            amount: proposition.montantTotal.toInt(),
          ),
        )
        .then((_) => _refreshLockStateFromServer(searchId));
  }

  void _showOnDemandInfoDialog() {
    AppDialog.show(
      title: 'Demande envoyée',
      description:
          'Votre demande a été transmise au propriétaire. Dès qu\'il répond sur la disponibilité, vous pourrez réserver.',
      primaryButtonText: 'Compris',
    );
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
        List<ReverseSearchProposition> socketProps = [];
        List<ResidenceModel> classicProps = [];
        String currentSearchId = "";
        ReverseSearchProposition? pendingSelection;
        DateTime? selectionExpireAt;

        state.maybeWhen(
          searching: (id, props, classic, pending, expireAt) {
            currentSearchId = id;
            pendingSelection = pending;
            selectionExpireAt = expireAt;
            // La résidence épinglée (en attente de paiement) est retirée de
            // la liste normale pour ne pas apparaître deux fois.
            socketProps = pending == null
                ? props
                : props.where((p) => p.data.id != pending.data.id).toList();
            classicProps = classic;
          },
          orElse: () {},
        );

        final libres = socketProps.length + (pendingSelection != null ? 1 : 0);
        final confirmer = classicProps.length;

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
                  searching: (searchId, socketProps, classicProps, _, __) {
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
                                    Text(
                                        _isExpired
                                            ? 'Recherche expirée'
                                            : 'Recherche en cours',
                                        style: TextStyle(
                                            color: _isExpired
                                                ? Colors.red.shade400
                                                : Colors.grey.shade500,
                                            fontSize: 13)),
                                    const SizedBox(height: 8),
                                    _expiresAt == null
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '--:--',
                                                style: TextStyle(
                                                    color:
                                                        Colors.orange.shade800,
                                                    fontSize: 36,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              _buildLibresEnAttenteRow(
                                                  libres, confirmer),
                                            ],
                                          )
                                        : SelectionCountdown(
                                            expireAt: _expiresAt!,
                                            onExpired: () {
                                              if (mounted && !_isExpired) {
                                                setState(
                                                    () => _isExpired = true);
                                                _showExpiredDialog(
                                                    currentSearchId);
                                              }
                                            },
                                            builder:
                                                (context, remaining, expired) {
                                              final totalSeconds = _createdAt
                                                  ?.difference(_expiresAt!)
                                                  .inSeconds
                                                  .abs();
                                              final progress =
                                                  (totalSeconds != null &&
                                                          totalSeconds > 0)
                                                      ? (remaining.inSeconds /
                                                              totalSeconds)
                                                          .clamp(0.0, 1.0)
                                                      : null;
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        expired
                                                            ? 'Expiré'
                                                            : formatCountdown(
                                                                remaining),
                                                        style: TextStyle(
                                                            color: expired
                                                                ? Colors.red
                                                                    .shade600
                                                                : Colors.orange
                                                                    .shade800,
                                                            fontSize: expired
                                                                ? 24
                                                                : 36,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      _buildLibresEnAttenteRow(
                                                          libres, confirmer),
                                                    ],
                                                  ),
                                                  if (progress != null &&
                                                      !expired) ...[
                                                    const SizedBox(height: 10),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      child:
                                                          LinearProgressIndicator(
                                                        value: progress,
                                                        minHeight: 6,
                                                        backgroundColor: Colors
                                                            .grey.shade200,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Colors.orange
                                                                    .shade800),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              );
                                            },
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
                                          borderRadius:
                                              BorderRadius.circular(22),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _showListNotifier.value =
                                                      false;
                                                  _sheetController.animateTo(
                                                      0.35,
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      curve: Curves.easeInOut);
                                                },
                                                child: ValueListenableBuilder<
                                                    bool>(
                                                  valueListenable:
                                                      _showListNotifier,
                                                  builder: (context, show, _) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color: !show
                                                            ? AppColors.primary
                                                            : Colors
                                                                .transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(22),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'Carte',
                                                        style: TextStyle(
                                                          color: !show
                                                              ? Colors.white
                                                              : Colors.black87,
                                                          fontWeight: !show
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
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
                                                  _showListNotifier.value =
                                                      true;
                                                  _sheetController.animateTo(
                                                      0.9,
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      curve: Curves.easeInOut);
                                                },
                                                child: ValueListenableBuilder<
                                                    bool>(
                                                  valueListenable:
                                                      _showListNotifier,
                                                  builder: (context, show, _) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color: show
                                                            ? AppColors.primary
                                                            : Colors
                                                                .transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(22),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'Liste',
                                                        style: TextStyle(
                                                          color: show
                                                              ? Colors.white
                                                              : Colors.black87,
                                                          fontWeight: show
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
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
                                child: Opacity(
                                  opacity: _isExpired ? 0.5 : 1,
                                  child: IgnorePointer(
                                    ignoring: _isExpired,
                                    child: Column(
                                      children: [
                                        // LIBRE TOUT DE SUITE
                                        const ReverseSearchListHeader(
                                          title: 'Libre tout de suite',
                                          description:
                                              'Le propriétaire à confirmer vous payer c\'est reserve',
                                        ),
                                        const SizedBox(height: 16),
                                        if (pendingSelection != null ||
                                            socketProps.isNotEmpty) ...[
                                          if (pendingSelection != null)
                                            PendingSelectionCard(
                                              proposition: pendingSelection!,
                                              selectionExpireAt:
                                                  selectionExpireAt,
                                              onContinuePayment: () =>
                                                  _continueToPayment(
                                                context,
                                                currentSearchId,
                                                pendingSelection!,
                                              ),
                                              onExpired: () => context
                                                  .read<ReverseSearchCubit>()
                                                  .clearPendingSelection(),
                                            ),
                                          ...socketProps.map(
                                            (prop) {
                                              final isImmediateBooking = true;
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 16.0),
                                                child: UnifiedPropertyCard(
                                                  item: prop.data,
                                                  badge: FreeReverseBadge(),
                                                  checkIn:
                                                      widget.request.dateDebut,
                                                  checkOut:
                                                      widget.request.dateFin,
                                                  showTotalLabel: true,
                                                  nights: prop.nombreNuits ??
                                                      widget.request.nights,
                                                  perNightPrice:
                                                      prop.prixParNuit,
                                                  fraisAmount:
                                                      prop.frais?.round(),
                                                  onTap: () {
                                                    inspect(prop);
                                                    _handleResidenceTap(
                                                        currentSearchId,
                                                        prop.data,
                                                        prop.montantTotal,
                                                        isImmediateBooking);
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 24),
                                        ] else
                                          const ReverseSearchWaitingBanner(),

                                        if (classicProps.isNotEmpty) ...[
                                          Opacity(
                                            // Toujours grisé et non-navigable : réservation directe impossible tant que le propriétaire n'a pas répondu.
                                            opacity: 0.55,
                                            child: Column(
                                              children: [
                                                ReverseSearchListHeader(
                                                  title: 'Sur demande',
                                                  description:
                                                      'Les ${classicProps.length} autres qui correspondent à votre besoin. En attente de réponse du propriétaire.',
                                                ),
                                                const SizedBox(height: 16),
                                                ...classicProps.map((prop) =>
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 16.0),
                                                      child:
                                                          UnifiedPropertyCard(
                                                        item: prop,
                                                        onTap:
                                                            _showOnDemandInfoDialog,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
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
