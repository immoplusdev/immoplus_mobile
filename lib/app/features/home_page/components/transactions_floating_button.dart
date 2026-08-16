import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/fast-track-book/reservation_engagement.dart';
import 'package:immoplus/app/features/fast-track-book/reservation_pending_smart.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

/// Bouton flottant "Transactions" — première étape.
///
/// Ouvre un menu flottant listant les réservations en cours (en attente de
/// réponse propriétaire / en attente de paiement), alimenté par la même
/// source de données que [ReservationEngagementFrame] /
/// `ReservationPendingBanner` (ResidenceRepository).
class TransactionsFloatingButton extends StatefulWidget {
  const TransactionsFloatingButton({super.key, this.scrollController});

  /// Scroll controller de la page hôte — écouté pour fermer le menu
  /// automatiquement dès que l'utilisateur scrolle la page en dessous.
  final ScrollController? scrollController;

  @override
  State<TransactionsFloatingButton> createState() =>
      _TransactionsFloatingButtonState();
}

class _TransactionsFloatingButtonState extends State<TransactionsFloatingButton>
    with SingleTickerProviderStateMixin {
  static const String _emptyHintShownKey = 'transactions_empty_hint_shown';

  late final AnimationController _animController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animController,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  bool _isLoading = true;
  List<ReservationModel> _pendingOwnerReservations = [];
  List<ReservationModel> _pendingPaymentReservations = [];

  final _sessionManager = getIt<SessionManager>();
  bool get _isLoggedIn => _sessionManager.currentUser != null;

  int get _pendingCount =>
      _pendingOwnerReservations.length + _pendingPaymentReservations.length;

  /// Une réservation attend un règlement : le badge annonce l'action à mener
  /// plutôt qu'un simple décompte, qui n'indiquait pas ce qui était attendu de
  /// l'utilisateur.
  bool get _hasPendingPayment => _pendingPaymentReservations.isNotEmpty;

  @override
  void initState() {
    super.initState();
    // Utilisateur non connecté : pas de réservations à charger, le bouton
    if (!_isLoggedIn) return;
    // Chargement initial (alimente le badge même menu fermé) + rafraîchi à
    unawaited(
        _refreshPendingReservations().then((_) => _maybeAutoOpenEmptyHint()));
    ReservationPendingBanner.pushNotifier.addListener(_onNewOperation);
    widget.scrollController?.addListener(_onScroll);
  }

  /// Ferme le menu dès que la page scrolle — évite qu'il reste affiché
  /// flottant au-dessus du contenu qui défile en dessous.
  void _onScroll() {
    if (_isOpen) unawaited(_closeMenu());
  }

  /// Ouvre le menu automatiquement à l'ouverture de l'app si l'utilisateur
  Future<void> _maybeAutoOpenEmptyHint() async {
    if (!mounted || _isOpen || _pendingCount > 0) return;

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_emptyHintShownKey) ?? false) return;
    await prefs.setBool(_emptyHintShownKey, true);

    if (!mounted || _isOpen) return;
    unawaited(_toggleMenu());
  }

  @override
  void dispose() {
    ReservationPendingBanner.pushNotifier.removeListener(_onNewOperation);
    widget.scrollController?.removeListener(_onScroll);
    _overlayEntry?.remove();
    _overlayEntry = null;
    _animController.dispose();
    super.dispose();
  }

  void _onNewOperation() {
    unawaited(_refreshPendingReservations());
  }

  Future<void> _refreshPendingReservations() async {
    final repo = getIt<ResidenceRepository>();
    final ownerFuture =
        repo.getReservationsEnAttenteProprietaire(page: 1, perPage: 20);
    final paymentFuture =
        repo.getReservationsEnAttentePaiement(page: 1, perPage: 20);

    final owner = await ownerFuture;
    final payment = await paymentFuture;
    if (!mounted) return;

    setState(() {
      _pendingOwnerReservations = owner.data;
      _pendingPaymentReservations = payment.data;
      _isLoading = false;
    });
    _overlayEntry?.markNeedsBuild();
  }

  Future<void> _closeMenu() async {
    if (!_isOpen) return;
    setState(() => _isOpen = false);
    await _animController.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _toggleMenu() async {
    if (_isOpen) {
      await _closeMenu();
      return;
    }

    setState(() => _isOpen = true);
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _animController.forward(from: 0);
    // Données déjà disponibles depuis le chargement initial/temps réel :
    // on rafraîchit juste au cas où, sans re-vider la liste (pas de flash).
    unawaited(_refreshPendingReservations());
  }

  void _openOwnerReservation(ReservationModel reservation) {
    unawaited(_closeMenu());
    context.pushNamed(
      ReservationEngagementFrame.name,
      extra: ReservationEngagementFrame(
        ownerName: reservation.residence.nom,
        reservationId: reservation.id,
        montantTotal: reservation.montantTotalReservation,
      ),
    );
  }

  void _openPayment(ReservationModel reservation) {
    unawaited(_closeMenu());
    context.pushNamed(
      OperatorsSelectorPage.name,
      extra: PaymentPageAdapter(
        itemId: reservation.id,
        collection: ProductType.reservations.name,
        amount: reservation.montantTotalReservation.toInt(),
      ),
    );
  }

  void _cancelReservation(ReservationModel reservation) {
    AppDialog.show(
      title: 'Annuler la réservation',
      description: 'Voulez-vous vraiment annuler cette réservation ?',
      primaryButtonText: 'Oui, annuler',
      secondButtonText: 'Non',
      onPrimary: () async {
        try {
          await getIt<ResidenceRepository>().annulerReservationClient(
            reservationId: reservation.id,
            notes: 'Annulé depuis le menu transactions',
          );
          ToastUtils.showSuccess(
            description: 'Réservation annulée avec succès',
          );
          ReservationPendingBanner.refresh();
          if (mounted) {
            setState(() {
              _pendingOwnerReservations = _pendingOwnerReservations
                  .where((r) => r.id != reservation.id)
                  .toList();
              _pendingPaymentReservations = _pendingPaymentReservations
                  .where((r) => r.id != reservation.id)
                  .toList();
            });
            _overlayEntry?.markNeedsBuild();
          }
        } catch (e) {
          ToastUtils.showError(description: 'Erreur lors de l\'annulation');
        }
      },
    );
  }

  OverlayEntry _buildOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, _) => Stack(
            children: [
              // Backdrop — ferme le menu au tap en dehors.
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _closeMenu,
                  child: const SizedBox.expand(),
                ),
              ),
              Positioned(
                right: 20,
                bottom: 15 + 48 + 12 + 48 + 12,
                child: FadeTransition(
                  opacity: _animation,
                  child: ScaleTransition(
                    scale: _animation,
                    alignment: Alignment.bottomRight,
                    child: Material(
                      color: Colors.transparent,
                      child: _TransactionsMenuPanel(
                        isLoading: _isLoading,
                        pendingOwnerReservations: _pendingOwnerReservations,
                        pendingPaymentReservations: _pendingPaymentReservations,
                        onTapOwnerReservation: _openOwnerReservation,
                        onTapPayment: _openPayment,
                        onCancel: _cancelReservation,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) return const SizedBox.shrink();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleMenu,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Center(
                child: _isOpen
                    ? Icon(Icons.close_rounded,
                        color: AppColors.primary, size: 24)
                    : const _TransactionsStackIcon(),
              ),
              // Un paiement en attente prime sur le décompte : c'est la seule
              // situation où l'utilisateur a quelque chose à faire.
              if (!_isOpen && _hasPendingPayment)
                Positioned(
                  top: -6,
                  right: -6,
                  child: _PendingPaymentBadge(
                    count: _pendingPaymentReservations.length,
                  ),
                )
              else if (!_isOpen && _pendingCount > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    constraints:
                        const BoxConstraints(minWidth: 18, minHeight: 18),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      _pendingCount > 99 ? '99+' : '$_pendingCount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pastille « À payer » du bouton flottant.
///
/// Reprend l'orange déjà associé au paiement dans le menu (icône portefeuille
/// `#B54708` sur `#FFFAEB`) pour que les deux se lisent comme une même chose.
/// Purement informative : c'est le bouton qui reste la cible tactile.
///
/// Positionnée avec `right` seul, elle s'étend vers la gauche et ne déborde
/// donc jamais de l'écran, quelle que soit la longueur du libellé.
///
/// Elle surgit à l'apparition puis rebondit brièvement toutes les quelques
/// secondes. Un rappel espacé plutôt qu'une pulsation continue : le bouton
/// reste affiché en permanence sur l'accueil, et une animation qui ne s'arrête
/// jamais y deviendrait vite un bruit de fond — coûteux et vite ignoré.
class _PendingPaymentBadge extends StatefulWidget {
  const _PendingPaymentBadge({required this.count});

  final int count;

  static const Color _amber = Color(0xFFF79009);

  @override
  State<_PendingPaymentBadge> createState() => _PendingPaymentBadgeState();
}

class _PendingPaymentBadgeState extends State<_PendingPaymentBadge>
    with SingleTickerProviderStateMixin {
  static const Duration _pulseInterval = Duration(seconds: 4);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
  );

  /// Apparition : la pastille jaillit depuis un point.
  late final Animation<double> _entrance = Tween<double>(
    begin: 0.4,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

  /// Rappel : détente puis léger contrecoup, sans repartir de zéro.
  late final Animation<double> _pulse = TweenSequence<double>(<
      TweenSequenceItem<double>>[
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 1.18)
          .chain(CurveTween(curve: Curves.easeOutCubic)),
      weight: 35,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.18, end: 0.94)
          .chain(CurveTween(curve: Curves.easeInOutCubic)),
      weight: 35,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 0.94, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOutBack)),
      weight: 30,
    ),
  ]).animate(_controller);

  Timer? _pulseTimer;
  bool _hasEntered = false;

  @override
  void initState() {
    super.initState();
    _controller.forward().whenComplete(() {
      if (mounted) _hasEntered = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respecte « Réduire les animations » du système : le badge reste alors
    // affiché, simplement immobile.
    _pulseTimer?.cancel();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1.0;
      _hasEntered = true;
      return;
    }
    _pulseTimer = Timer.periodic(_pulseInterval, (_) {
      if (mounted && _hasEntered) _controller.forward(from: 0);
    });
  }

  @override
  void didUpdateWidget(_PendingPaymentBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Une réservation à payer de plus : on le signale tout de suite plutôt que
    // d'attendre le prochain rappel.
    if (oldWidget.count != widget.count && _hasEntered) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pulseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.count > 1 ? '${widget.count} à payer' : 'À payer';

    return Semantics(
      label: widget.count > 1
          ? '${widget.count} réservations à payer'
          : 'Une réservation à payer',
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _hasEntered ? _pulse.value : _entrance.value,
          child: child,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: _PendingPaymentBadge._amber,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: _PendingPaymentBadge._amber.withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              height: 1.1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

/// Mini pile de 3 cartes-images en éventail, avec rotation/décalage subtils
/// et permutation périodique des positions (effet "shuffle").
class _TransactionsStackIcon extends StatefulWidget {
  const _TransactionsStackIcon();

  @override
  State<_TransactionsStackIcon> createState() => _TransactionsStackIconState();
}

class _StackSlot {
  const _StackSlot({
    required this.left,
    required this.top,
    required this.angle,
    required this.opacity,
  });

  final double left;
  final double top;
  final double angle;
  final double opacity;
}

class _TransactionsStackIconState extends State<_TransactionsStackIcon> {
  static const List<String> _images = [
    'assets/img/residence.png',
    'assets/img/terrain.png',
    'assets/img/meuble.png',
  ];

  static const List<_StackSlot> _slots = [
    _StackSlot(left: 2, top: 10, angle: -0.13, opacity: 0.82), // arrière
    _StackSlot(left: 12, top: 6, angle: 0.12, opacity: 0.9), // milieu
    _StackSlot(left: 7, top: 12, angle: 0.0, opacity: 1), // avant-plan
  ];

  static const Duration _shuffleInterval = Duration(seconds: 3);
  static const Duration _moveDuration = Duration(milliseconds: 550);

  Timer? _shuffleTimer;
  List<int> _slotForImage = [0, 1, 2];

  @override
  void initState() {
    super.initState();
    _shuffleTimer = Timer.periodic(_shuffleInterval, (_) {
      if (!mounted) return;
      setState(() {
        _slotForImage = _slotForImage.map((s) => (s + 1) % 3).toList();
      });
    });
  }

  @override
  void dispose() {
    _shuffleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ordre de peinture arrière → avant, selon le slot courant de chaque image.
    final paintOrder = List<int>.generate(3, (i) => i)
      ..sort((a, b) => _slotForImage[a].compareTo(_slotForImage[b]));

    return SizedBox(
      width: 34,
      height: 34,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final imageIndex in paintOrder)
            _buildImage(imageIndex, _slots[_slotForImage[imageIndex]]),
        ],
      ),
    );
  }

  Widget _buildImage(int imageIndex, _StackSlot slot) {
    return AnimatedPositioned(
      key: ValueKey(_images[imageIndex]),
      duration: _moveDuration,
      curve: Curves.easeInOutCubic,
      left: slot.left,
      top: slot.top,
      child: AnimatedRotation(
        turns: slot.angle / (2 * math.pi),
        duration: _moveDuration,
        curve: Curves.easeInOutCubic,
        child: AnimatedOpacity(
          opacity: slot.opacity,
          duration: _moveDuration,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 3,
                  offset: const Offset(0, 1.5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(_images[imageIndex], fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}

class _TransactionsMenuPanel extends StatelessWidget {
  const _TransactionsMenuPanel({
    required this.isLoading,
    required this.pendingOwnerReservations,
    required this.pendingPaymentReservations,
    required this.onTapOwnerReservation,
    required this.onTapPayment,
    required this.onCancel,
  });

  final bool isLoading;
  final List<ReservationModel> pendingOwnerReservations;
  final List<ReservationModel> pendingPaymentReservations;
  final void Function(ReservationModel) onTapOwnerReservation;
  final void Function(ReservationModel) onTapPayment;
  final void Function(ReservationModel) onCancel;

  bool get _hasNothing =>
      pendingOwnerReservations.isEmpty && pendingPaymentReservations.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      constraints: const BoxConstraints(maxHeight: 320),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Text(
              'Mes réservations',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 4),
          if (isLoading)
            const _TransactionsMenuSkeleton()
          else if (_hasNothing)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 4),
              child: Text(
                'Retrouvez ici toutes vos réservations et demandes de visite, où que vous soyez.',
                style: TextStyle(fontSize: 13, color: Color(0xFF667085)),
              ),
            )
          else
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final reservation in pendingOwnerReservations)
                      _TransactionCard(
                        key: ValueKey('owner_${reservation.id}'),
                        icon: Iconsax.clock,
                        iconColor: const Color(0xFF2744DE),
                        iconBg: const Color(0xFFF8F6FF),
                        title: 'Réservation en attente',
                        subtitle: reservation.residence.nom.isNotEmpty
                            ? reservation.residence.nom
                            : 'En attente de réponse du propriétaire',
                        onTap: () => onTapOwnerReservation(reservation),
                        onCancel: () => onCancel(reservation),
                      ),
                    for (final reservation in pendingPaymentReservations)
                      _TransactionCard(
                        key: ValueKey('payment_${reservation.id}'),
                        icon: Iconsax.wallet_2,
                        iconColor: const Color(0xFFB54708),
                        iconBg: const Color(0xFFFFFAEB),
                        title: 'Réservation à payer',
                        subtitle: Utils.formatCurrency(
                            reservation.montantTotalReservation),
                        onTap: () => onTapPayment(reservation),
                        onCancel: () => onCancel(reservation),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TransactionsMenuSkeleton extends StatelessWidget {
  const _TransactionsMenuSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SkeletonRow(),
          _SkeletonRow(),
        ],
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                  width: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 8,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
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

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onCancel,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 18, 4),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF667085),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -4,
            right: -4,
            child: _CloseCircleButton(onPressed: onCancel),
          ),
        ],
      ),
    );
  }
}

class _CloseCircleButton extends StatelessWidget {
  const _CloseCircleButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Color(0xFFF2F4F7),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close_rounded,
            size: 13,
            color: Color(0xFF667085),
          ),
        ),
      ),
    );
  }
}
