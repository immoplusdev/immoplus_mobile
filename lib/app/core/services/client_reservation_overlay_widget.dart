import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:intl/intl.dart';

import 'client_reservation_overlay_service.dart';

class ClientReservationOverlayWidget extends StatefulWidget {
  final ReservationModel reservation;
  final ClientReservationOverlayState overlayState;
  final VoidCallback onDismiss;
  final VoidCallback onPayNow;

  const ClientReservationOverlayWidget({
    super.key,
    required this.reservation,
    required this.overlayState,
    required this.onDismiss,
    required this.onPayNow,
  });

  @override
  State<ClientReservationOverlayWidget> createState() =>
      _ClientReservationOverlayWidgetState();
}

class _ClientReservationOverlayWidgetState
    extends State<ClientReservationOverlayWidget> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  final DateFormat _dateFormat = DateFormat('d MMM yyyy');

  // Durées totales pour la barre de progression
  static const int _totalWaitingProprietaire = 120; // 2 min
  static const int _totalWaitingPayment = 420; // 7 min

  @override
  void initState() {
    super.initState();
    _computeRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _computeRemaining());
    });
  }

  void _computeRemaining() {
    final raw =
        widget.overlayState == ClientReservationOverlayState.waitingProprietaire
            ? widget.reservation.delaisProprietaireReponse
            : widget.reservation.delaisPaiementClient;
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
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Color _timerColor() {
    final seconds = _remaining.inSeconds;
    if (seconds > 60) return Colors.green;
    if (seconds > 30) return Colors.orange;
    return Colors.red;
  }

  double _progressValue() {
    final total =
        widget.overlayState == ClientReservationOverlayState.waitingProprietaire
            ? _totalWaitingProprietaire
            : _totalWaitingPayment;
    return (_remaining.inSeconds / total).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final isWaitingPayment =
        widget.overlayState == ClientReservationOverlayState.waitingPayment;
    final residence = widget.reservation.residence;
    final imageUrl =
        residence.images.isNotEmpty ? residence.images.first : null;

    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    isWaitingPayment ? Icons.check_circle : Icons.notifications,
                    color: isWaitingPayment ? Colors.green : AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isWaitingPayment
                          ? 'Réservation confirmée !'
                          : 'En attente de confirmation',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onDismiss,
                    child: const Icon(Icons.close, size: 20, color: Colors.grey),
                  ),
                ],
              ),

              const Divider(height: 16),

              // Residence info
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.home, color: Colors.grey),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.home, color: Colors.grey),
                            ),
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.home, color: Colors.grey),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          residence.nom,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_dateFormat.format(Utils.toDateTime(widget.reservation.dateDebut))} → ${_dateFormat.format(Utils.toDateTime(widget.reservation.dateFin))}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Utils.formatCurrency(
                              widget.reservation.montantTotalReservation),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 16),

              // Timer
              Row(
                children: [
                  Icon(
                    isWaitingPayment ? Icons.credit_card : Icons.timer,
                    size: 16,
                    color: _timerColor(),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      isWaitingPayment
                          ? 'Finalisez votre paiement dans : ${_formatDuration(_remaining)}'
                          : 'Le propriétaire répond dans : ${_formatDuration(_remaining)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: _timerColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progressValue(),
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(_timerColor()),
                  minHeight: 6,
                ),
              ),

              // Pay button (only for waitingPayment)
              if (isWaitingPayment) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: widget.onPayNow,
                    icon: const Icon(Icons.credit_card, size: 18),
                    label: const Text('Payer maintenant'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
