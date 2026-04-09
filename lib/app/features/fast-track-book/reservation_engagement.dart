import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/reservations/status_reservation.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/fast-track-book/reservation_pending_smart.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/constants/constantes.dart';

/// Frame C3 — L'Engagement Humain (L'Attente)
///
/// Architecture :
///   • [ReservationPendingBanner] = source de vérité des STATUTS.
///   • Cette frame affiche des messages humains simples (pas de countdown).
///   • Polling agressif (5s) via softRefresh tant que la frame est visible.
class ReservationEngagementFrame extends StatefulWidget {
  static const String name = 'reservation_engagement';

  final String ownerName;
  final String reservationId;
  final double montantTotal;
  final VoidCallback? onBackHome;

  const ReservationEngagementFrame({
    super.key,
    required this.ownerName,
    required this.reservationId,
    required this.montantTotal,
    this.onBackHome,
  });

  @override
  State<ReservationEngagementFrame> createState() =>
      _ReservationEngagementFrameState();
}

class _ReservationEngagementFrameState extends State<ReservationEngagementFrame>
    with TickerProviderStateMixin {
  // ── Rotation messages ───────────────────────────────────────────────────────
  late AnimationController _messageController;
  late Animation<double> _messageOpacity;
  int _messageIndex = 0;
  Timer? _messageRotationTimer;

  // ── Polling agressif (5s) tant que la frame est visible ─────────────────────
  Timer? _aggressiveRefreshTimer;
  static const Duration _aggressiveInterval = Duration(seconds: 5);

  // ── Messages rotatifs — waitingOwner ────────────────────────────────────────
  static const List<String> _waitingOwnerMessages = [
    '👀 Le propriétaire regarde votre demande…',
    '📅 Le propriétaire vérifie les disponibilités…',
    '✨ Votre logement est disponible…',
    '⏳ Plus qu\'un instant…',
  ];

  // ── Messages rotatifs — waitingPayment ──────────────────────────────────────
  static const List<String> _waitingPaymentMessages = [
    '💳 Finalisez pour confirmer',
    '🔒 Votre place est réservée',
    '⚡ Un dernier pas…',
  ];

  // ── État local ──────────────────────────────────────────────────────────────
  ReservationBannerState _currentState = ReservationBannerState.idle;
  late double _montantTotal;
  bool _isFetchingReservation = false;

  // ── Couleurs ────────────────────────────────────────────────────────────────
  static const Color _primaryBlue = Color(0xFF2744DE);
  static const Color _successGreen = Color(0xFF22C55E);
  static const Color _warningOrange = Color(0xFFF68A3A);
  static const Color _errorRed = Color(0xFFE63946);
  static const Color _bgColor = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textSecondary = Color(0xFF666666);

  @override
  void initState() {
    super.initState();

    _currentState = ReservationPendingBanner.bannerStateNotifier.value;
    _montantTotal = widget.montantTotal;

    _messageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: 1.0,
    );
    _messageOpacity = CurvedAnimation(
      parent: _messageController,
      curve: Curves.easeInOut,
    );

    if (_currentState == ReservationBannerState.waitingOwner ||
        _currentState == ReservationBannerState.waitingPayment) {
      _startMessageRotation();
    }

    ReservationPendingBanner.bannerStateNotifier.addListener(_onStateChanged);
    ReservationPendingBanner.pushNotifier.addListener(_onPushReceived);

    // ── Polling agressif : fetch API directement toutes les 5s ──────────────
    _startAggressiveRefresh();
  }

  // ── Push notification → re-fetch immédiat ─────────────────────────────────
  void _onPushReceived() {
    if (!mounted || _isTerminal) return;
    _pollReservation();
  }

  // ── Polling agressif — fetch API directement (le banner est démonté) ────────
  void _startAggressiveRefresh() {
    _pollReservation(); // refresh immédiat

    _aggressiveRefreshTimer?.cancel();
    _aggressiveRefreshTimer = Timer.periodic(_aggressiveInterval, (_) {
      if (!mounted || _isTerminal) {
        _aggressiveRefreshTimer?.cancel();
        return;
      }
      _pollReservation();
    });
  }

  /// Fetch direct de la réservation depuis l'API et mise à jour du state.
  Future<void> _pollReservation() async {
    if (_isFetchingReservation) return;
    _isFetchingReservation = true;
    try {
      final repo = getIt<ResidenceRepository>();
      final response = await repo.getReservation(id: widget.reservationId);
      if (!mounted) return;

      final reservation = response.data;
      final status = StatusReservation.fromString(
          reservation.statusReservation);

      // Détermine le nouvel état
      ReservationBannerState newState;
      switch (status) {
        case StatusReservation.enAttenteReponseProprietaire:
          newState = ReservationBannerState.waitingOwner;
          break;
        case StatusReservation.enAttentePaiementClient:
          newState = ReservationBannerState.waitingPayment;
          break;
        case StatusReservation.rejete:
        case StatusReservation.proprietaireAnnuleReservation:
          newState = ReservationBannerState.endedRefused;
          break;
        case StatusReservation.proprietaireSansReponse:
          newState = ReservationBannerState.endedWaitingExpired;
          break;
        case StatusReservation.clientSansReponse:
          newState = ReservationBannerState.endedPaymentExpired;
          break;
        default:
          newState = ReservationBannerState.idle;
      }

      // Met à jour le montant frais
      _montantTotal = reservation.montantTotalReservation;

      // Met à jour le notifier (pour cohérence) + état local
      ReservationPendingBanner.bannerStateNotifier.value = newState;

      if (_currentState != newState) {
        setState(() {
          _currentState = newState;
          _messageIndex = 0;
        });
        _handleNewState(newState);
      }
    } catch (_) {
      // En cas d'erreur réseau, on garde l'état actuel
    } finally {
      _isFetchingReservation = false;
    }
  }

  // ── Listener : changement de statut (backup si banner remonté) ─────────────
  void _onStateChanged() {
    if (!mounted) return;
    final newState = ReservationPendingBanner.bannerStateNotifier.value;
    if (_currentState == newState) return;
    setState(() {
      _currentState = newState;
      _messageIndex = 0;
    });
    _handleNewState(newState);
  }

  // ── Gestion centralisée d'un changement d'état ────────────────────────────
  void _handleNewState(ReservationBannerState newState) {
    switch (newState) {
      case ReservationBannerState.waitingOwner:
        _startMessageRotation();
        break;

      case ReservationBannerState.waitingPayment:
        _startMessageRotation();
        break;

      case ReservationBannerState.endedRefused:
      case ReservationBannerState.endedWaitingExpired:
      case ReservationBannerState.endedPaymentExpired:
        _messageRotationTimer?.cancel();
        _aggressiveRefreshTimer?.cancel();
        break;

      case ReservationBannerState.idle:
        _messageRotationTimer?.cancel();
        _aggressiveRefreshTimer?.cancel();
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) context.goNamed(HomePage.name);
        });
        break;
    }
  }

  // ── Rotation messages ───────────────────────────────────────────────────────
  void _startMessageRotation() {
    _messageRotationTimer?.cancel();
    _messageRotationTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted) return;
      if (_currentState == ReservationBannerState.waitingOwner ||
          _currentState == ReservationBannerState.waitingPayment) {
        _rotateMessage();
      }
    });
  }

  List<String> get _activeMessages =>
      _currentState == ReservationBannerState.waitingPayment
          ? _waitingPaymentMessages
          : _waitingOwnerMessages;

  void _rotateMessage() async {
    await _messageController.reverse();
    if (!mounted) return;
    setState(
        () => _messageIndex = (_messageIndex + 1) % _activeMessages.length);
    await _messageController.forward();
  }

  @override
  void dispose() {
    _aggressiveRefreshTimer?.cancel();
    _messageRotationTimer?.cancel();
    ReservationPendingBanner.bannerStateNotifier
        .removeListener(_onStateChanged);
    ReservationPendingBanner.pushNotifier.removeListener(_onPushReceived);
    _messageController.dispose();
    super.dispose();
  }

  bool get _isTerminal =>
      _currentState == ReservationBannerState.endedRefused ||
      _currentState == ReservationBannerState.endedWaitingExpired ||
      _currentState == ReservationBannerState.endedPaymentExpired;

  // ── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Demande de réservation',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textPrimary),
          onPressed: () => context.goNamed(HomePage.name),
        ),
      ),
      body: Stack(
        children: [
          Container(color: Colors.white),

          // ── Lottie ──────────────────────────────────────────────────────────
          Positioned(
            top: -80,
            left: 0,
            right: 0,
            height: 580,
            child: Lottie.asset(
              _currentState == ReservationBannerState.waitingPayment
                  ? 'assets/lotties/success.json'
                  : 'assets/lotties/agenda.json',
              fit: BoxFit.contain,
              repeat: _currentState != ReservationBannerState.waitingPayment && !_isTerminal,
              animate: true,
            ),
          ),

          // ── Sheet ────────────────────────────────────────────────────────────
          DraggableScrollableSheet(
            initialChildSize: 0.52,
            minChildSize: 0.48,
            maxChildSize: 0.60,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: _bgColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        widget.ownerName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.verify, color: _primaryBlue, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Hôte vérifié',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _primaryBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Badge statut ──────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: _buildStatusBadge(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Info contextuelle (remplace le timer) ─────────────
                      if (!_isTerminal) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildContextCard(),
                        ),
                        const SizedBox(height: 20),
                      ] else
                        const SizedBox(height: 4),

                      // ── Boutons ───────────────────────────────────────────
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: _buildActions(),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Badge statut ────────────────────────────────────────────────────────────
  Widget _buildStatusBadge() {
    switch (_currentState) {
      case ReservationBannerState.waitingOwner:
        return FadeTransition(
          key: const ValueKey('waiting_owner_msg'),
          opacity: _messageOpacity,
          child: Text(
            _waitingOwnerMessages[_messageIndex % _waitingOwnerMessages.length],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _textSecondary,
              height: 1.5,
            ),
          ),
        );

      case ReservationBannerState.waitingPayment:
        return _statusChip(
          key: const ValueKey('waiting_payment'),
          icon: Iconsax.wallet_check,
          label: '🎉 Propriétaire a confirmé !',
          sublabel: 'Finalisez votre paiement pour réserver',
          bg: const Color(0xFFEBFFF3),
          border: const Color(0xFF86EFAC),
          iconColor: _successGreen,
          textColor: const Color(0xFF166534),
        );

      case ReservationBannerState.endedRefused:
        return _statusChip(
          key: const ValueKey('ended_refused'),
          icon: Iconsax.minus_cirlce,
          label: 'Résidence non disponible',
          sublabel: 'Cette résidence est occupée, choisissez-en une autre.',
          bg: const Color(0xFFFFEAEA),
          border: const Color(0xFFFF6B6B),
          iconColor: _errorRed,
          textColor: _errorRed,
        );

      case ReservationBannerState.endedWaitingExpired:
        return _statusChip(
          key: const ValueKey('ended_waiting_expired'),
          icon: Iconsax.call_slash3,
          label: 'Demande expirée',
          sublabel: 'Le propriétaire n\'a pas répondu à temps.',
          bg: const Color(0xFFFFEAEA),
          border: const Color(0xFFFF6B6B),
          iconColor: _errorRed,
          textColor: _errorRed,
        );

      case ReservationBannerState.endedPaymentExpired:
        return _statusChip(
          key: const ValueKey('ended_payment_expired'),
          icon: Iconsax.card_remove,
          label: 'Délai de paiement atteint',
          sublabel: 'Votre réservation n\'a pu aboutir.',
          bg: const Color(0xFFFFF4E6),
          border: const Color(0xFFFFB84D),
          iconColor: _warningOrange,
          textColor: _warningOrange,
        );

      case ReservationBannerState.idle:
        return const SizedBox.shrink(key: ValueKey('idle'));
    }
  }

  Widget _statusChip({
    required Key key,
    required IconData icon,
    required String label,
    required String sublabel,
    required Color bg,
    required Color border,
    required Color iconColor,
    required Color textColor,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  sublabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor.withOpacity(0.75),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Card contextuelle (remplace le timer) ─────────────────────────────────
  Widget _buildContextCard() {
    final isPayment = _currentState == ReservationBannerState.waitingPayment;

    final Color cardColor = isPayment ? _warningOrange : _primaryBlue;
    final Color cardBg =
        isPayment ? const Color(0xFFFFF4E6) : const Color(0xFFF8F6FF);

    final IconData cardIcon = isPayment ? Iconsax.clock : Iconsax.message_text;
    final String cardTitle = isPayment
        ? 'Payez dans les prochaines minutes'
        : 'Répond habituellement dans un court délai.';
    final String cardSubtitle = isPayment
        ? 'Votre place est maintenue, ne tardez pas'
        : 'Vous serez notifié dès sa réponse';

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Container(
        key: ValueKey('context_${isPayment ? 'payment' : 'owner'}'),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 40,
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(cardIcon, color: cardColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardTitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: cardColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    cardSubtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: cardColor.withOpacity(0.7),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Boutons ─────────────────────────────────────────────────────────────────
  Widget _buildActions() {
    switch (_currentState) {
      case ReservationBannerState.waitingOwner:
        return _outlineButton(
          key: const ValueKey('btn_waiting_owner'),
          icon: Iconsax.save_2,
          label: 'Sauvegarder et Quitter',
          onPressed: () => context.goNamed(HomePage.name),
        );

      case ReservationBannerState.waitingPayment:
        return Column(
          key: const ValueKey('btn_waiting_payment'),
          children: [
            _primaryButton(
              icon: Iconsax.wallet_2,
              label: 'Effectuer le paiement',
              color: _successGreen,
              onPressed: () => context.pushNamed(
                OperatorsSelectorPage.name,
                extra: PaymentPageAdapter(
                  itemId: widget.reservationId,
                  collection: ProductType.reservations.name,
                  amount: _montantTotal.toInt(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _textBtn(
              label: 'Sauvegarder et Quitter',
              onPressed: () => context.goNamed(HomePage.name),
            ),
          ],
        );

      case ReservationBannerState.endedRefused:
      case ReservationBannerState.endedWaitingExpired:
      case ReservationBannerState.endedPaymentExpired:
        return _primaryButton(
          key: const ValueKey('btn_ended'),
          icon: Iconsax.search_normal_1,
          label: 'Découvrir d\'autres biens',
          color: _primaryBlue,
          onPressed: () => context.goNamed(HomePage.name),
        );

      case ReservationBannerState.idle:
        return const SizedBox.shrink(key: ValueKey('btn_idle'));
    }
  }

  Widget _primaryButton({
    Key? key,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Text(label,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _outlineButton({
    Key? key,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: _primaryBlue,
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: _primaryBlue, width: 1.5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Text(label,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textBtn({
    Key? key,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12)),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _textSecondary),
          ),
        ),
      ),
    );
  }
}
