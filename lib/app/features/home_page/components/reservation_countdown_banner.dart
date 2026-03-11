import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/data/models/remote/reservations/status_reservation.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';

class ReservationCountdownBanner extends StatefulWidget {
  const ReservationCountdownBanner({super.key});

  /// Notifier statique pour relancer le fetch depuis l'extérieur
  static final ValueNotifier<int> refreshNotifier = ValueNotifier<int>(0);

  /// Appeler cette méthode pour rafraîchir le banner
  static void refresh() => refreshNotifier.value++;

  @override
  State<ReservationCountdownBanner> createState() =>
      _ReservationCountdownBannerState();
}

class _ReservationCountdownBannerState
    extends State<ReservationCountdownBanner> {
  ReservationModel? _reservation;
  StatusReservation? _status;
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchReservation();
    ReservationCountdownBanner.refreshNotifier.addListener(_onRefresh);
  }

  void _onRefresh() {
    _timer?.cancel();
    _reservation = null;
    _status = null;
    _loading = true;
    if (mounted) setState(() {});
    _fetchReservation();
  }

  Future<void> _fetchReservation() async {
    final repo = getIt<ResidenceRepository>();

    // 1. En attente réponse propriétaire
    final pending = await repo.getLatestPendingProprietaireReponse();
    if (pending != null) {
      _setReservation(pending, StatusReservation.enAttenteReponseProprietaire);
      return;
    }

    // 2. En attente paiement client
    try {
      final result =
          await repo.getReservationsEnAttentePaiement(page: 1, perPage: 1);
      if (result.data.isNotEmpty) {
        _setReservation(
            result.data.first, StatusReservation.enAttentePaiementClient);
        return;
      }
    } catch (_) {}

    if (mounted) setState(() => _loading = false);
  }

  void _setReservation(ReservationModel reservation, StatusReservation status) {
    _reservation = reservation;
    _status = status;
    _computeRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _computeRemaining());
    });
    if (mounted) setState(() => _loading = false);
  }

  void _computeRemaining() {
    final raw = _status == StatusReservation.enAttenteReponseProprietaire
        ? _reservation?.delaisProprietaireReponse
        : _reservation?.delaisPaiementClient;
    final deadline = DateTime.tryParse(raw ?? '');
    if (deadline == null) {
      _remaining = Duration.zero;
      return;
    }
    final diff = deadline.difference(DateTime.now());
    _remaining = diff.isNegative ? Duration.zero : diff;
  }

  @override
  void dispose() {
    _timer?.cancel();
    ReservationCountdownBanner.refreshNotifier.removeListener(_onRefresh);
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Color _timerColor() {
    final sec = _remaining.inSeconds;
    if (sec > 60) return Colors.green;
    if (sec > 30) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _reservation == null) return const SizedBox.shrink();

    final isPayment = _status == StatusReservation.enAttentePaiementClient;

    return GestureDetector(
      onTap: isPayment
          ? () {
              context.pushNamed(
                OperatorsSelectorPage.name,
                extra: PaymentPageAdapter(
                  itemId: _reservation!.id,
                  collection: ProductType.reservations.name,
                  amount: _reservation!.montantTotalReservation.toInt(),
                ),
              );
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 0, top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isPayment
              ? Colors.green.shade50
              : AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPayment
                ? Colors.green.shade200
                : AppColors.primary.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isPayment ? Icons.credit_card : Icons.access_time_rounded,
              size: 18,
              color: isPayment ? Colors.green.shade700 : _timerColor(),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPayment
                        ? 'Reservation confirmee — ${_reservation!.residence.nom}'
                        : 'En attente — ${_reservation!.residence.nom}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isPayment
                        ? 'Payez dans ${_formatDuration(_remaining)} — ${Utils.formatCurrency(_reservation!.montantTotalReservation)}'
                        : 'Reponse du proprietaire dans ${_formatDuration(_remaining)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: _timerColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isPayment) ...[
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Payer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
