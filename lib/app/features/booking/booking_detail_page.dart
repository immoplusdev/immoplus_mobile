// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/data/enums/rating_status.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_response.dart';
import 'package:immoplus/app/features/authentification/loading_page.dart';
import 'package:immoplus/app/features/booking/logic/booking_cubit.dart';
import 'package:immoplus/app/features/booking/logic/booking_request_state.dart';
import 'package:immoplus/app/features/booking/widgets/logment_info.dart';
import 'package:immoplus/app/features/rating/widgets/rating_bottom_sheet.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/booking_utils.dart';
import 'package:immoplus/app/utils/contact_utils.dart';
import 'dart:async';
import 'package:immoplus/app/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookingDetailPage extends StatefulWidget {
  const BookingDetailPage(
      {super.key, required this.id, this.autoShowRating = false});
  static String name = 'BOOKING';
  static String routePath = '/reservation/:id';
  static String route({required String id, String? action}) {
    return '/reservation/$id${action != null ? '?action=$action' : ''}';
  }

  final String id;
  final bool autoShowRating;

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  bool _hasAutoShownRating = false;
  String? _qrPayload;
  bool _isLoadingQr = false;
  String? _qrError;
  Timer? _qrTimer;

  @override
  void initState() {
    super.initState();
    context.read<BookingCubit>().getBooking(id: widget.id);
  }

  @override
  void dispose() {
    _qrTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadQrCheckin() async {
    if (!mounted) return;
    _qrTimer?.cancel();
    setState(() {
      _isLoadingQr = true;
      _qrError = null;
    });

    try {
      final repository = context.read<BookingCubit>().residenceRepository;
      final response = await repository.generateQrCheckin(id: widget.id);
      if (!mounted) return;

      final data = response['data'] as Map<String, dynamic>?;
      if (data != null && data['qrPayload'] != null) {
        final payload = data['qrPayload'] as String;
        final refreshSeconds = data['refreshInSeconds'] as int? ?? 45;
        setState(() {
          _qrPayload = payload;
          _isLoadingQr = false;
        });
        _qrTimer = Timer(Duration(seconds: refreshSeconds), _loadQrCheckin);
      } else {
        setState(() {
          _isLoadingQr = false;
          _qrError = "Impossible de charger le code QR";
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingQr = false;
        _qrError = "Erreur de connexion pour le code QR";
      });
      _qrTimer = Timer(const Duration(seconds: 10), _loadQrCheckin);
    }
  }

  bool hasPaid(ReservationResponse r) =>
      r.data.statusFacture.toString() == PaymentStatus.paye.name;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingRequestState>(
      listener: (context, state) {
        if (state is RECEIVE_BOOKING) {
          final res = state.reservationResponse.data;
          final paid = hasPaid(state.reservationResponse);
          if (res.isCheckinValide) {
            _qrTimer?.cancel();
            _qrTimer = null;
          }
          if (paid &&
              res.checkinNotValide &&
              _qrPayload == null &&
              !_isLoadingQr &&
              _qrError == null) {
            _loadQrCheckin();
          }
          if (widget.autoShowRating &&
              !_hasAutoShownRating &&
              res.ratingStatus == RatingStatus.pending) {
            _hasAutoShownRating = true;
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final result =
                  await RatingBottomSheet.show(context, reservation: res);
              if (result == true && mounted) {
                context.read<BookingCubit>().getBooking(id: widget.id);
              }
            });
          }
        }
      },
      builder: (context, state) {
        if (state is RECEIVE_BOOKING) {
          final res = state.reservationResponse.data;
          final paid = hasPaid(state.reservationResponse);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Iconsax.arrow_left, color: Colors.black),
                onPressed: () =>
                    context.canPop() ? context.pop() : context.go('/'),
              ),
              title: const Text('Détails réservation'),
              titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
              centerTitle: false,
            ),
            body: RefreshIndicator(
              onRefresh: () async =>
                  context.read<BookingCubit>().getBooking(id: widget.id),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                children: [
                  // ── Logement ──
                  LogmentInfo(logmentModel: res.residence),
                  const Gap(12),

                  // ── Statuts ──
                  _SectionCard(
                    children: [
                      // _StatusRow(
                      //   icon: Iconsax.clipboard_tick,
                      //   label: 'Statut réservation',
                      //   status: res.statusReservation,
                      // ),
                      // const _CardDivider(),
                      _StatusRow(
                        icon: Iconsax.wallet,
                        label: 'Statut paiement',
                        status: res.statusFacture,
                      ),
                    ],
                  ),
                  const Gap(12),

                  // ── Dates ──
                  _DatesCard(reservationModel: res),
                  const Gap(12),

                  // ── Prix total ──
                  _SectionCard(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _IconBox(
                                icon: Iconsax.receipt_item,
                                color: AppColors.primary,
                              ),
                              const Gap(12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.grey[500]),
                                  ),
                                  Text(
                                    '${res.datesReservation.length} '
                                    '${res.datesReservation.length > 1 ? 'jours' : 'jour'}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            Utils.formatCurrency(res.montantPaye),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1CA53F),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Gap(12),

                  // ── Identifiant ──
                  _SectionCard(
                    children: [
                      Row(
                        children: [
                          _IconBox(icon: Iconsax.tag, color: Colors.purple),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ID réservation',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey[500]),
                                ),
                                SelectableText(
                                  res.id,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.purple,
                                        fontFamily: 'monospace',
                                      ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Iconsax.copy,
                                color: AppColors.primary, size: 18),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: res.id))
                                  .then((_) => EasyLoading.showToast(
                                      'Identifiant copié'));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Gap(12),

                  // ── Code réservation (si payé) ──
                  if (paid) ...[
                    _SectionCard(
                      children: [
                        InkWell(
                          onTap: () =>
                              Utils.copyToClipboard(res.codeReservation),
                          borderRadius: BorderRadius.circular(12),
                          child: Row(
                            children: [
                              _IconBox(
                                  icon: Iconsax.password_check,
                                  color: AppColors.primary),
                              const Gap(12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Code réservation',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.grey[500]),
                                    ),
                                    Text(
                                      res.codeReservation,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                            letterSpacing: 2,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Iconsax.copy,
                                  color: AppColors.primary, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),

                    // ── Propriétaire (si payé) ──
                    _SectionCard(
                      children: [
                        InkWell(
                          onTap: () {
                            final phone =
                                res.proprietaire.phoneNumber.split('-');
                            Utils.makePhoneCall(phone.last);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Row(
                            children: [
                              _IconBox(
                                  icon: Iconsax.user, color: Colors.orange),
                              const Gap(12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Propriétaire',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.grey[500]),
                                    ),
                                    Text(
                                      res.proprietaire.phoneNumber
                                          .split('-')
                                          .last,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Iconsax.call,
                                  color: AppColors.primary, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                  ],

                  // ── Actions ──
                  _SectionCard(
                    children: [
                      _ActionRow(
                        icon: Iconsax.location,
                        label: "Voir l'itinéraire",
                        iconColor: AppColors.primary,
                        onTap: () async {
                          if (await MapLauncher.isMapAvailable(
                                  MapType.google) ??
                              false) {
                            MapLauncher.showDirections(
                              destinationTitle: res.residence.nom,
                              destination: Coords(
                                res.residence.position.coordinates![1],
                                res.residence.position.coordinates![0],
                              ),
                              directionsMode: DirectionsMode.driving,
                              mapType: MapType.google,
                            );
                          } else {
                            final maps = await MapLauncher.installedMaps;
                            if (maps.isNotEmpty) {
                              maps.first.showDirections(
                                destinationTitle: res.residence.nom,
                                destination: Coords(
                                  res.residence.position.coordinates![1],
                                  res.residence.position.coordinates![0],
                                ),
                                directionsMode: DirectionsMode.driving,
                              );
                            }
                          }
                        },
                      ),
                      const _CardDivider(),
                      _ActionRow(
                        icon: Iconsax.headphone,
                        label: 'Support client',
                        iconColor: Colors.deepPurple,
                        onTap: () => ContactUtils.showContact(id: widget.id),
                      ),
                    ],
                  ),
                  if (paid && res.checkinNotValide) ...[
                    const Gap(12),
                    _buildQrCheckinSection(),
                  ],
                ],
              ),
            ),

            // ── Bottom CTA si non payé ──
            bottomNavigationBar: res.statusFacture ==
                    PaymentStatus.non_paye.name
                ? SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: FilledButton.icon(
                        onPressed: () => context.pushNamed(
                          OperatorsSelectorPage.name,
                          extra: PaymentPageAdapter(
                            itemId: res.id,
                            collection: ProductType.reservations.name,
                            amount: res.montantPaye.toInt(),
                          ),
                        ),
                        icon: const Icon(Iconsax.wallet, size: 18),
                        label: Text(
                          'Payer maintenant · ${Utils.formatCurrency(res.montantPaye)}',
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF1CA53F),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  )
                : res.ratingStatus == RatingStatus.pending
                    ? SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          child: FilledButton.icon(
                            onPressed: () async {
                              final result = await RatingBottomSheet.show(
                                  context,
                                  reservation: res);
                              if (result == true && context.mounted) {
                                context
                                    .read<BookingCubit>()
                                    .getBooking(id: widget.id);
                              }
                            },
                            icon: const Icon(Iconsax.star, size: 18),
                            label: const Text('Évaluer mon séjour'),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF2548E5),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      )
                    : (res.ratingStatus == RatingStatus.rated ||
                            res.ratingStatus == RatingStatus.expired)
                        ? SafeArea(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 8, 16, 12),
                              child: FilledButton.icon(
                                onPressed: null,
                                icon: Icon(
                                  res.ratingStatus == RatingStatus.rated
                                      ? Iconsax.star1
                                      : Iconsax.clock,
                                  size: 18,
                                ),
                                label: Text(
                                  res.ratingStatus == RatingStatus.rated
                                      ? 'Déjà noté'
                                      : 'Notation expirée',
                                ),
                                style: FilledButton.styleFrom(
                                  disabledBackgroundColor:
                                      Colors.grey.shade300,
                                  disabledForegroundColor:
                                      Colors.grey.shade600,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : null,
          );
        }

        if (state is Error_BOOKINGS) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.scafold,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Iconsax.arrow_left, color: Colors.black),
                onPressed: () =>
                    context.canPop() ? context.pop() : context.go('/'),
              ),
            ),
            backgroundColor: AppColors.scafold,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Iconsax.info_circle,
                        size: 72, color: Colors.grey[400]),
                    const Gap(16),
                    Text(
                      "Impossible de charger cette réservation.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                    const Gap(24),
                    FilledButton.icon(
                      onPressed: () => context
                          .read<BookingCubit>()
                          .getBooking(id: widget.id),
                      icon: const Icon(Iconsax.refresh, size: 16),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const LoadingPage();
      },
    );
  }

  Widget _buildQrCheckinSection() {
    return _SectionCard(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                _IconBox(icon: Iconsax.scan_barcode, color: Colors.blue),
                const Gap(12),
                Expanded(
                  child: Text(
                    'Présentez ce code QR à l\'arrivée',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[500]),
                  ),
                ),
              ],
            ),
            const Gap(16),
            if (_isLoadingQr && _qrPayload == null)
              const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_qrError != null && _qrPayload == null)
              SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _qrError!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(8),
                      TextButton.icon(
                        onPressed: _loadQrCheckin,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Réessayer'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_qrPayload != null) ...[
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: _qrPayload!,
                      version: QrVersions.auto,
                      size: 180.0,
                      gapless: false,
                    ),
                  ),
                  if (_isLoadingQr)
                    Container(
                      width: 204,
                      height: 204,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
              const Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const Gap(8),
                  Text(
                    'Mise à jour automatique sécurisée...',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}

// ── Carte conteneur ─────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 20, thickness: 0.5);
}

// ── Icône carrée ─────────────────────────────────────────────────────────────

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon, required this.color});
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }
}

// ── Ligne statut ─────────────────────────────────────────────────────────────

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.icon,
    required this.label,
    required this.status,
  });
  final IconData icon;
  final String label;
  final String status;

  Color _color() {
    if (status == PaymentStatus.paye.name ||
        status == 'accepte' ||
        status == 'confirme') {
      return const Color(0xFF1CA53F);
    }
    if (status == 'refuse' || status == 'annule') {
      return Colors.red;
    }
    return Colors.orange;
  }

  String _text() => Utils.getServiceStatus(status);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconBox(icon: icon, color: _color()),
        const Gap(12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _color().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _text(),
            style: TextStyle(
              color: _color(),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Ligne action ─────────────────────────────────────────────────────────────

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          _IconBox(icon: icon, color: iconColor),
          const Gap(12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Icon(Iconsax.arrow_right_3, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }
}

// ── Carte dates ──────────────────────────────────────────────────────────────

class _DatesCard extends StatelessWidget {
  const _DatesCard({required this.reservationModel});
  final ReservationModel reservationModel;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('EEE d MMM yyyy');
    final checkin = Utils.toDateTime(reservationModel.dateDebut);
    final checkout = Utils.toDateTime(reservationModel.dateFin);

    final bookingStatus = BookingUtils.getBookingStatus(
      reservationModel.datesReservation.first.date!,
      reservationModel.datesReservation.last.date!,
    );
    final statusText = BookingUtils.getStatusText(
      startDate: reservationModel.datesReservation.first.date!,
      endDate: reservationModel.datesReservation.last.date!,
    );
    final statusColor = bookingStatus == BookingStatus.ongoing
        ? const Color(0xFF1CA53F)
        : AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: [
          // Badge statut
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.07),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(
                  bookingStatus == BookingStatus.ongoing
                      ? Iconsax.people
                      : Iconsax.calendar_tick,
                  size: 14,
                  color: statusColor,
                ),
                const Gap(6),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Arrivée / Départ
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _DateCell(
                    label: 'ARRIVÉE',
                    date: fmt.format(checkin),
                    hour: reservationModel.residence.heureEntree,
                    icon: Iconsax.login,
                    color: const Color(0xFF1CA53F),
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey.shade200,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
                Expanded(
                  child: _DateCell(
                    label: 'DÉPART',
                    date: fmt.format(checkout),
                    hour: reservationModel.residence.heureDepart,
                    icon: Iconsax.logout,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateCell extends StatelessWidget {
  const _DateCell({
    required this.label,
    required this.date,
    required this.hour,
    required this.icon,
    required this.color,
  });
  final String label;
  final String date;
  final String? hour;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: color),
            const Gap(4),
            Text(
              label,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: 0.5),
            ),
          ],
        ),
        const Gap(4),
        Text(
          date,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (hour != null && hour!.isNotEmpty) ...[
          const Gap(2),
          Text(
            hour!,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ],
    );
  }
}
