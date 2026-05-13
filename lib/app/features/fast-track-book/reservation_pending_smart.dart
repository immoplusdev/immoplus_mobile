import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/data/models/remote/reservations/status_reservation.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/fast-track-book/reservation_engagement.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// État terminal du banner
// ─────────────────────────────────────────────────────────────────────────────
enum _EndState {
  none,
  proprietaireRefused,
  waitingExpired,
  paymentExpired,
}

// ─────────────────────────────────────────────────────────────────────────────
// ReservationBannerState — partagé avec ReservationEngagementFrame
// ─────────────────────────────────────────────────────────────────────────────
enum ReservationBannerState {
  idle,
  waitingOwner,
  waitingPayment,
  endedRefused,
  endedWaitingExpired,
  endedPaymentExpired,
}

class ReservationPendingBanner extends StatefulWidget {
  const ReservationPendingBanner({super.key});

  // ── Notifier : refresh externe (hard reset) ────────────────────────────────
  static final ValueNotifier<int> refreshNotifier = ValueNotifier<int>(0);
  static void refresh() => refreshNotifier.value++;

  // ── Notifier : soft refresh (re-fetch silencieux, pas de reset UI) ─────────
  static final ValueNotifier<int> softRefreshNotifier = ValueNotifier<int>(0);
  static void softRefresh() => softRefreshNotifier.value++;

  // ── Notifier : présence réservation (pilote toolbarHeight) ─────────────────
  static final ValueNotifier<bool> hasReservationNotifier =
      ValueNotifier<bool>(false);
  static void setHasReservation(bool value) =>
      hasReservationNotifier.value = value;

  // ── Notifier : état global partagé ─────────────────────────────────────────
  static final ValueNotifier<ReservationBannerState> bannerStateNotifier =
      ValueNotifier<ReservationBannerState>(ReservationBannerState.idle);

  // ── Notifier : deadline ISO brute (source de vérité pour le countdown) ─────
  static final ValueNotifier<String?> deadlineNotifier =
      ValueNotifier<String?>(null);

  // ── Notifier : secondes totales (barre de progression) ─────────────────────
  static final ValueNotifier<int> totalSecondsNotifier = ValueNotifier<int>(1);

  // ── Notifier : push notification reçue → force un re-fetch immédiat ───────
  static final ValueNotifier<int> pushNotifier = ValueNotifier<int>(0);
  static void onPushReceived() => pushNotifier.value++;

  @override
  State<ReservationPendingBanner> createState() =>
      _ReservationPendingBannerState();
}

class _ReservationPendingBannerState extends State<ReservationPendingBanner>
    with TickerProviderStateMixin {
  // ── API state ───────────────────────────────────────────────────────────────
  ReservationModel? _reservation;
  StatusReservation? _status;
  bool _loading = true;

  // ── État terminal ────────────────────────────────────────────────────────────
  _EndState _endState = _EndState.none;
  bool _showingEndMessage = false;
  bool _autoCancelInProgress = false;

  // ── Countdown interne ────────────────────────────────────────────────────────
  int _secondsLeft = 0;
  int _totalSeconds = 1;
  Timer? _countdownTimer;

  // ── Re-fetch périodique ──────────────────────────────────────────────────────
  Timer? _refreshTimer;
  static const Duration _refreshInterval = Duration(seconds: 30);

  // ── Guard anti-concurrent soft refresh ──────────────────────────────────────
  bool _softRefreshInProgress = false;

  // ── Messages rotatifs ───────────────────────────────────────────────────────
  final List<String> _rotatingMessages = [
    'Le propriétaire consulte les dates de votre séjour…',
    'Votre logement est toujours disponible.',
    'Plus qu\'un instant…',
    'La confirmation arrive vite.',
  ];
  int _messageIndex = 0;
  Timer? _messageTimer;

  // ── Animations ──────────────────────────────────────────────────────────────
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _messageController;
  late Animation<double> _messageOpacity;

  // ── Couleurs ────────────────────────────────────────────────────────────────
  static const Color _bgColor = Color(0xFFFFFFFF);
  static const Color _iconBg = Color(0xFFAB8DFF);
  static const Color _accentLight = Color(0xFFEEE8FF);
  static const Color _textPrimary = Color(0xFF1A1A1A);
  static const Color _textMuted = Color(0xFF888888);
  static const Color _errorBg = Color(0xFFFF5A5A);

  final sessionManager = getIt<SessionManager>();

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _fetchReservation();
    _startPeriodicRefresh();
    ReservationPendingBanner.refreshNotifier.addListener(_onForceRefresh);
    ReservationPendingBanner.softRefreshNotifier.addListener(_onSoftRefresh);
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.88, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _messageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 1.0,
    );
    _messageOpacity = CurvedAnimation(
      parent: _messageController,
      curve: Curves.easeInOut,
    );
  }

  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_refreshInterval, (_) {
      if (_showingEndMessage) return;
      _silentRefresh();
    });
  }

  // ── Hard refresh (reset complet de l'UI) ───────────────────────────────────
  void _onForceRefresh() {
    _cancelAllTimers();
    _autoCancelInProgress = false;
    _softRefreshInProgress = false;
    ReservationPendingBanner.deadlineNotifier.value = null;
    if (mounted) {
      setState(() {
        _reservation = null;
        _status = null;
        _loading = true;
        _secondsLeft = 0;
        _endState = _EndState.none;
        _showingEndMessage = false;
      });
    }
    _fetchReservation();
    _startPeriodicRefresh();
  }

  // ── Soft refresh (re-fetch silencieux, pas de reset UI) ────────────────────
  void _onSoftRefresh() {
    if (_softRefreshInProgress || _showingEndMessage || _autoCancelInProgress) {
      return;
    }
    _silentRefresh();
  }

  void _cancelAllTimers() {
    _countdownTimer?.cancel();
    _messageTimer?.cancel();
    _refreshTimer?.cancel();
  }

  // ── Publie la deadline + total vers les notifiers ───────────────────────────
  void _publishDeadline(String? deadlineISO, int totalSeconds) {
    ReservationPendingBanner.deadlineNotifier.value = deadlineISO;
    ReservationPendingBanner.totalSecondsNotifier.value = totalSeconds;
  }

  Future<void> _fetchReservation() async {
    if (sessionManager.currentUser == null) {
      return;
    }
    final repo = getIt<ResidenceRepository>();
    final pending = await repo.getLatestPendingProprietaireReponse();
    if (pending != null) {
      _setReservation(pending, StatusReservation.enAttenteReponseProprietaire);
      return;
    }
    try {
      final result =
          await repo.getReservationsEnAttentePaiement(page: 1, perPage: 1);
      if (result.data.isNotEmpty) {
        _setReservation(
            result.data.first, StatusReservation.enAttentePaiementClient);
        return;
      }
    } catch (e) {
      debugPrint('[ReservationPending] Error: $e');
    }
    ReservationPendingBanner.setHasReservation(false);
    ReservationPendingBanner.bannerStateNotifier.value =
        ReservationBannerState.idle;
    ReservationPendingBanner.deadlineNotifier.value = null;
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _silentRefresh() async {
    if (_autoCancelInProgress || _showingEndMessage) return;

    // Guard anti-concurrent
    if (_softRefreshInProgress) return;
    _softRefreshInProgress = true;

    try {
      final repo = getIt<ResidenceRepository>();

      final pending = await repo.getLatestPendingProprietaireReponse();
      if (pending != null) {
        _updateIfChanged(
            pending, StatusReservation.enAttenteReponseProprietaire);
        return;
      }
      try {
        final result =
            await repo.getReservationsEnAttentePaiement(page: 1, perPage: 1);
        if (result.data.isNotEmpty) {
          _updateIfChanged(
              result.data.first, StatusReservation.enAttentePaiementClient);
          return;
        }
      } catch (_) {}

      if (_reservation != null &&
          _secondsLeft > 0 &&
          _status == StatusReservation.enAttenteReponseProprietaire) {
        _triggerEndMessage(_EndState.proprietaireRefused);
        return;
      }
      if (_reservation != null) {
        ReservationPendingBanner.setHasReservation(false);
        ReservationPendingBanner.bannerStateNotifier.value =
            ReservationBannerState.idle;
        ReservationPendingBanner.deadlineNotifier.value = null;
        if (mounted) setState(() => _reservation = null);
      }
    } finally {
      _softRefreshInProgress = false;
    }
  }

  void _updateIfChanged(ReservationModel newRes, StatusReservation newStatus) {
    // Même réservation, même statut → rien à faire
    if (_reservation?.id == newRes.id && _status == newStatus) return;
    _cancelAllTimers();
    _setReservation(newRes, newStatus);
  }

  void _setReservation(ReservationModel reservation, StatusReservation status) {
    _reservation = reservation;
    _status = status;
    _endState = _EndState.none;
    _showingEndMessage = false;
    _autoCancelInProgress = false;
    _computeSeconds();
    _startCountdown();
    _startMessageRotation();
    ReservationPendingBanner.setHasReservation(true);
    ReservationPendingBanner.bannerStateNotifier.value =
        status == StatusReservation.enAttentePaiementClient
            ? ReservationBannerState.waitingPayment
            : ReservationBannerState.waitingOwner;

    // ── Publie la deadline brute — la frame calcule ses propres secondes ──────
    final rawDeadline = status == StatusReservation.enAttenteReponseProprietaire
        ? reservation.delaisProprietaireReponse
        : reservation.delaisPaiementClient;
    _publishDeadline(rawDeadline, _totalSeconds);

    if (mounted) setState(() => _loading = false);
  }

  void _computeSeconds() {
    final isProprietaire =
        _status == StatusReservation.enAttenteReponseProprietaire;
    final rawDeadline = isProprietaire
        ? _reservation!.delaisProprietaireReponse
        : _reservation!.delaisPaiementClient;
    final deadline = DateTime.tryParse(rawDeadline ?? '');
    if (deadline == null) {
      _secondsLeft = 0;
      _totalSeconds = 1;
      return;
    }
    final remaining = deadline.difference(DateTime.now());
    _secondsLeft = remaining.isNegative ? 0 : remaining.inSeconds;

    DateTime? created;
    try {
      final raw = _reservation!.createdAt;
      created = (raw is DateTime ? raw : DateTime.tryParse(raw.toString()))
          as DateTime?;
    } catch (_) {}
    _totalSeconds = created != null
        ? deadline.difference(created).inSeconds.clamp(1, 999999)
        : const Duration(hours: 24).inSeconds;
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _countdownTimer?.cancel();
        _handleCountdownZero();
      }
    });
  }

  Future<void> _handleCountdownZero() async {
    if (_autoCancelInProgress || _reservation == null) return;
    _autoCancelInProgress = true;
    _cancelAllTimers();

    final reservationId = _reservation!.id;
    final endState = _status == StatusReservation.enAttentePaiementClient
        ? _EndState.paymentExpired
        : _EndState.waitingExpired;

    try {
      final repo = getIt<ResidenceRepository>();
      await repo.annulerReservationClient(
        reservationId: reservationId,
        notes: endState == _EndState.paymentExpired
            ? 'Délai de paiement expiré — annulation automatique'
            : 'Délai de réponse propriétaire expiré — annulation automatique',
      );
    } catch (e) {
      debugPrint('[ReservationPending] Auto-cancel error: $e');
    }
    _triggerEndMessage(endState);
  }

  void _triggerEndMessage(_EndState state) {
    if (!mounted) return;
    _cancelAllTimers();

    final hideDelay = state == _EndState.proprietaireRefused
        ? const Duration(seconds: 3)
        : const Duration(seconds: 5);

    final bannerState = switch (state) {
      _EndState.proprietaireRefused => ReservationBannerState.endedRefused,
      _EndState.waitingExpired => ReservationBannerState.endedWaitingExpired,
      _EndState.paymentExpired => ReservationBannerState.endedPaymentExpired,
      _EndState.none => ReservationBannerState.idle,
    };
    ReservationPendingBanner.bannerStateNotifier.value = bannerState;
    ReservationPendingBanner.deadlineNotifier.value = null;

    setState(() {
      _endState = state;
      _showingEndMessage = true;
    });

    Timer(hideDelay, () {
      if (!mounted) return;
      setState(() {
        _reservation = null;
        _showingEndMessage = false;
        _endState = _EndState.none;
        _autoCancelInProgress = false;
      });
      ReservationPendingBanner.setHasReservation(false);
    });
  }

  void _startMessageRotation() {
    _messageTimer?.cancel();
    _messageTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (mounted) _rotateMessage();
    });
  }

  void _rotateMessage() async {
    await _messageController.reverse();
    if (!mounted) return;
    setState(
        () => _messageIndex = (_messageIndex + 1) % _rotatingMessages.length);
    await _messageController.forward();
  }

  void _handleTap() {
    if (_showingEndMessage) return;
    if (_status == StatusReservation.enAttentePaiementClient) {
      context.pushNamed(
        OperatorsSelectorPage.name,
        extra: PaymentPageAdapter(
          itemId: _reservation!.id,
          collection: ProductType.reservations.name,
          amount: _reservation!.montantTotalReservation.toInt(),
        ),
      );
      return;
    }
    if (_status == StatusReservation.enAttenteReponseProprietaire) {
      context.pushNamed(
        ReservationEngagementFrame.name,
        extra: ReservationEngagementFrame(
          ownerName: _reservation!.residence.nom,
          reservationId: _reservation!.id,
          montantTotal: _reservation!.montantTotalReservation,
        ),
      );
    }
  }

  @override
  void dispose() {
    _cancelAllTimers();
    _pulseController.dispose();
    _messageController.dispose();
    ReservationPendingBanner.refreshNotifier.removeListener(_onForceRefresh);
    ReservationPendingBanner.softRefreshNotifier.removeListener(_onSoftRefresh);
    super.dispose();
  }

  String get _formattedTime {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  double get _progressRatio => (_secondsLeft / _totalSeconds).clamp(0.0, 1.0);

  String get _endTitle {
    switch (_endState) {
      case _EndState.proprietaireRefused:
        return 'Résidence non disponible';
      case _EndState.waitingExpired:
        return 'Demande expirée';
      case _EndState.paymentExpired:
        return 'Délai de paiement atteint';
      case _EndState.none:
        return '';
    }
  }

  String get _endSubtitle {
    switch (_endState) {
      case _EndState.proprietaireRefused:
        return 'Cette résidence est occupée, choisissez-en une autre.';
      case _EndState.waitingExpired:
        return 'Le propriétaire n\'a pas répondu à temps. Réessayez plus tard.';
      case _EndState.paymentExpired:
        return 'Temps limite de paiement atteint, votre réservation n\'a pu aboutir.';
      case _EndState.none:
        return '';
    }
  }

  IconData get _endIcon {
    switch (_endState) {
      case _EndState.proprietaireRefused:
        return Iconsax.minus_cirlce;
      case _EndState.waitingExpired:
        return Iconsax.call_slash3;
      case _EndState.paymentExpired:
        return Iconsax.card_remove;
      case _EndState.none:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showingEndMessage && _endState != _EndState.none) {
      return _buildEndMessageBanner();
    }
    if (_loading || _reservation == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFAB8DFF).withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ajoutez votre condition ici.
                  // Si la condition est fausse, le Container ne sera pas rendu et l'Expanded prendra sa place.
                  // if (showContainer == true)
                  // Container(
                  //   width: 64,
                  //   color: const Color.fromARGB(255, 255, 255, 255),
                  //   child: Center(
                  //     child: ScaleTransition(
                  //       scale: _pulseAnimation,
                  //       child: Container(
                  //         width: 38,
                  //         height: 38,
                  //         decoration: BoxDecoration(
                  //           color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.25),
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // L'Expanded va automatiquement s'étirer pour prendre la place du Container si le "if" ci-dessus est faux.
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _status == StatusReservation.enAttentePaiementClient
                                ? 'Propriétaire a confirmé votre demande'
                                : 'Le propriétaire regarde votre demande',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _textPrimary,
                              height: 1.25,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          FadeTransition(
                            opacity: _messageOpacity,
                            child: Text(
                              _status ==
                                      StatusReservation.enAttentePaiementClient
                                  ? 'Finalisez votre paiement pour confirmer'
                                  : _rotatingMessages[_messageIndex],
                              style: const TextStyle(
                                fontSize: 11,
                                color: _textMuted,
                                height: 1.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: _textMuted,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )

            // _buildProgressBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildEndMessageBanner() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
            offset: Offset(0, 8 * (1 - value)), child: child),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _errorBg.withOpacity(0.10),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 64,
                color: _errorBg,
                child: Center(
                    child: Icon(_endIcon, color: Colors.white, size: 22)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _endTitle,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                          height: 1.25,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _endSubtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: _textMuted,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: Icon(Icons.close_rounded,
                      color: _textMuted.withOpacity(0.5), size: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          Container(height: 3, color: const Color(0xFFF0EEF8)),
          AnimatedContainer(
            duration: const Duration(milliseconds: 900),
            curve: Curves.linear,
            height: 3,
            width: constraints.maxWidth * _progressRatio,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _progressRatio > 0.3
                    ? [const Color(0xFFAB8DFF), const Color(0xFF7C5CBF)]
                    : [const Color(0xFFFF8A8A), const Color(0xFFFF5A5A)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
