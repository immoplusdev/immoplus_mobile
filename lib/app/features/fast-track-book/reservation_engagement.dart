import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/fast-track-book/reservation_pending_smart.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/constants/constantes.dart';

/// Frame C3 — L'Engagement Humain (L'Attente)
///
/// Architecture :
///   • [ReservationPendingBanner] = source de vérité des STATUTS.
///   • Cette frame = autonome pour le COUNTDOWN.
///
/// Fix timer figé :
///   La frame NE lit plus secondsLeftNotifier (valeur dépendante d'un tick
///   externe). Elle lit deadlineNotifier (ISO string) et recalcule les
///   secondes ELLE-MÊME via DateTime.now(). Résultat : toujours correct
///   au montage, même si le banner est disposé ou entre deux ticks.
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

class _ReservationEngagementFrameState
    extends State<ReservationEngagementFrame> with TickerProviderStateMixin {

  // ── Countdown LOCAL autonome ────────────────────────────────────────────────
  Timer? _localCountdownTimer;

  // ── Rotation messages ───────────────────────────────────────────────────────
  late AnimationController _messageController;
  late Animation<double> _messageOpacity;
  int _messageIndex = 0;
  Timer? _messageRotationTimer;

  static const List<String> _waitingMessages = [
    '👀 Le propriétaire regarde votre demande...',
    '📅 Il consulte les dates de votre séjour...',
    '✨ Votre logement est toujours disponible...',
    '⏳ Plus qu\'un instant, il arrive...',
  ];

  // ── État local ──────────────────────────────────────────────────────────────
  ReservationBannerState _currentState = ReservationBannerState.idle;
  int _secondsLeft  = 0;
  int _totalSeconds = 1;

  // ── Couleurs ────────────────────────────────────────────────────────────────
  static const Color _primaryBlue   = Color(0xFF2744DE);
  static const Color _successGreen  = Color(0xFF22C55E);
  static const Color _warningOrange = Color(0xFFF68A3A);
  static const Color _errorRed      = Color(0xFFE63946);
  static const Color _bgColor       = Color(0xFFFFFFFF);
  static const Color _textPrimary   = Color(0xFF1A1A1A);
  static const Color _textSecondary = Color(0xFF666666);

  @override
  void initState() {
    super.initState();

    // ── Lecture initiale de l'état ────────────────────────────────────────────
    _currentState = ReservationPendingBanner.bannerStateNotifier.value;
    _totalSeconds = ReservationPendingBanner.totalSecondsNotifier.value;

    // ── Calcul secondes depuis la deadline brute ──────────────────────────────
    // Pas de dépendance à secondsLeftNotifier → toujours juste au montage.
    _secondsLeft = _computeSecondsFromDeadline(
      ReservationPendingBanner.deadlineNotifier.value,
    );

    // ── Animation messages ────────────────────────────────────────────────────
    _messageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: 1.0,
    );
    _messageOpacity = CurvedAnimation(
      parent: _messageController,
      curve: Curves.easeInOut,
    );

    // ── Démarrage countdown autonome ──────────────────────────────────────────
    _startLocalCountdown();

    if (_currentState == ReservationBannerState.waitingOwner) {
      _startMessageRotation();
    }

    // ── Abonnement notifiers ──────────────────────────────────────────────────
    // On écoute deadlineNotifier (pas secondsLeftNotifier) pour les resyncs.
    ReservationPendingBanner.bannerStateNotifier .addListener(_onStateChanged);
    ReservationPendingBanner.deadlineNotifier    .addListener(_onDeadlineChanged);
    ReservationPendingBanner.totalSecondsNotifier.addListener(_onTotalChanged);
  }

  // ── Calcul secondes depuis deadline ISO ────────────────────────────────────
  // Appelé à l'init et à chaque changement de deadline.
  // Retourne toujours une valeur correcte, même si le banner est disposé.
  int _computeSecondsFromDeadline(String? deadlineISO) {
    if (deadlineISO == null) return 0;
    final deadline = DateTime.tryParse(deadlineISO);
    if (deadline == null) return 0;
    final remaining = deadline.difference(DateTime.now());
    return remaining.isNegative ? 0 : remaining.inSeconds;
  }

  // ── Countdown local ─────────────────────────────────────────────────────────
  void _startLocalCountdown() {
    _localCountdownTimer?.cancel();
    if (_secondsLeft <= 0) return;

    _localCountdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _localCountdownTimer?.cancel();
        // Le banner gère l'auto-cancel API et la transition de statut.
      }
    });
  }

  // ── Listener : changement de statut ────────────────────────────────────────
  void _onStateChanged() {
    if (!mounted) return;
    final newState = ReservationPendingBanner.bannerStateNotifier.value;
    setState(() => _currentState = newState);

    switch (newState) {
      case ReservationBannerState.waitingPayment:
        // Propriétaire a accepté → nouveau délai paiement.
        // La deadline a déjà été mise à jour dans deadlineNotifier par le banner.
        // _onDeadlineChanged va s'en charger automatiquement.
        _messageRotationTimer?.cancel();
        break;

      case ReservationBannerState.endedRefused:
      case ReservationBannerState.endedWaitingExpired:
      case ReservationBannerState.endedPaymentExpired:
        _localCountdownTimer?.cancel();
        _messageRotationTimer?.cancel();
        break;

      case ReservationBannerState.idle:
        _localCountdownTimer?.cancel();
        _messageRotationTimer?.cancel();
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) context.goNamed(HomePage.name);
        });
        break;

      case ReservationBannerState.waitingOwner:
        // Resync au cas où on repasserait sur ce statut
        _localCountdownTimer?.cancel();
        _secondsLeft = _computeSecondsFromDeadline(
          ReservationPendingBanner.deadlineNotifier.value,
        );
        _startLocalCountdown();
        _startMessageRotation();
        break;
    }
  }

  // ── Listener : nouvelle deadline publiée par le banner ─────────────────────
  // Déclenché quand le statut change (ex: waitingOwner → waitingPayment).
  // La frame recalcule ses secondes depuis la nouvelle deadline ISO.
  void _onDeadlineChanged() {
    if (!mounted) return;
    final newSeconds = _computeSecondsFromDeadline(
      ReservationPendingBanner.deadlineNotifier.value,
    );
    if (newSeconds <= 0) return;

    _localCountdownTimer?.cancel();
    setState(() => _secondsLeft = newSeconds);
    _startLocalCountdown();

    debugPrint('[EngagementFrame] Deadline resync → $_secondsLeft s');
  }

  // ── Listener : total secondes ───────────────────────────────────────────────
  void _onTotalChanged() {
    if (!mounted) return;
    setState(() {
      _totalSeconds = ReservationPendingBanner.totalSecondsNotifier.value;
    });
  }

  // ── Rotation messages ───────────────────────────────────────────────────────
  void _startMessageRotation() {
    _messageRotationTimer?.cancel();
    _messageRotationTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (!mounted) return;
      if (_currentState == ReservationBannerState.waitingOwner) _rotateMessage();
    });
  }

  void _rotateMessage() async {
    await _messageController.reverse();
    if (!mounted) return;
    setState(() => _messageIndex = (_messageIndex + 1) % _waitingMessages.length);
    await _messageController.forward();
  }

  @override
  void dispose() {
    _localCountdownTimer?.cancel();
    _messageRotationTimer?.cancel();
    ReservationPendingBanner.bannerStateNotifier .removeListener(_onStateChanged);
    ReservationPendingBanner.deadlineNotifier    .removeListener(_onDeadlineChanged);
    ReservationPendingBanner.totalSecondsNotifier.removeListener(_onTotalChanged);
    _messageController.dispose();
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────
  String get _formattedTime {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    if (m > 0) return '$m min ${s}s';
    return '${s}s';
  }

  double get _progressRatio => (_secondsLeft / _totalSeconds).clamp(0.0, 1.0);

  bool get _isTerminal =>
      _currentState == ReservationBannerState.endedRefused        ||
      _currentState == ReservationBannerState.endedWaitingExpired  ||
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
          'Confirmation de réservation',
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
              'assets/lotties/agenda.json',
              fit: BoxFit.contain,
              repeat: !_isTerminal,
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

                      // ── Timer + barre ─────────────────────────────────────
                      if (!_isTerminal) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildTimerCard(),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildProgressBar(),
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
            _waitingMessages[_messageIndex],
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

  // ── Card timer ──────────────────────────────────────────────────────────────
  Widget _buildTimerCard() {
    final isPayment = _currentState == ReservationBannerState.waitingPayment;
    final bool isUrgent = _secondsLeft < 120 && _secondsLeft > 0;

    final Color timerColor = isUrgent
        ? _errorRed
        : isPayment ? _warningOrange : _primaryBlue;

    final Color timerBg = isUrgent
        ? const Color(0xFFFFEAEA)
        : isPayment ? const Color(0xFFFFF4E6) : const Color(0xFFF8F6FF);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: timerBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Iconsax.timer_1, color: timerColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPayment ? 'Temps restant pour payer' : 'Temps de réponse',
                  style: const TextStyle(
                    fontSize: 12,
                    color: _textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_formattedTime restant',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: timerColor,
                  ),
                ),
              ],
            ),
          ),
          if (isUrgent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _errorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Urgent',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _errorRed,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Barre de progression ────────────────────────────────────────────────────
  Widget _buildProgressBar() {
    final isPayment = _currentState == ReservationBannerState.waitingPayment;
    final Color barColor = _progressRatio < 0.3
        ? _errorRed
        : isPayment ? _warningOrange : _primaryBlue;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: _progressRatio,
        minHeight: 5,
        backgroundColor: const Color(0xFFF0EEF8),
        valueColor: AlwaysStoppedAnimation<Color>(barColor),
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
                  amount: widget.montantTotal.toInt(),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
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
          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textSecondary),
          ),
        ),
      ),
    );
  }
}