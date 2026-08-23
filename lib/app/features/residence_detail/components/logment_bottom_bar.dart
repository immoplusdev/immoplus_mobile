import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:immoplus/app/core/services/auth_redirect_service.dart';
import 'package:immoplus/app/core/services/reverse_search_socket_service.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/models/remote/reverse_search/reverse_search_model.dart';
import 'package:immoplus/app/data/repositories/reverse_search_repository.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/features/booking/booking_formular_action.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/features/residence_detail/components/pending_reverse_search_banner.dart';
import 'package:immoplus/app/features/residence_detail/components/reverse_search_pay_bar.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/features/suggest/logic/reverse_search_navigation.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// CONTENEUR PRINCIPAL : Affiche la barre appropriée selon le mode
/// ─────────────────────────────────────────────────────────────────────────────
class LogmentBottomBar extends StatefulWidget {
  const LogmentBottomBar({
    super.key,
    required this.residenceModel,
    this.isImmediateBooking = false,
    this.reverseSearchId,
    this.reverseSearchPrice,
  });

  final ResidenceModel residenceModel;
  final bool isImmediateBooking;
  final String? reverseSearchId;
  final double? reverseSearchPrice;

  @override
  State<LogmentBottomBar> createState() => _LogmentBottomBarState();
}

class _LogmentBottomBarState extends State<LogmentBottomBar> {
  final _sessionManager = getIt<SessionManager>();

  bool _isLocking = false;
  ReverseSearchItem? _activeReverseSearch;
  StreamSubscription<String>? _socketStatusSub;

  /// Cette résidence est celle actuellement verrouillée (statut
  /// `selection_en_attente_paiement`, `residenceSelectionnee` == cette page).
  bool get _isThisResidenceLocked =>
      _activeReverseSearch?.statusEnum.isSelectionEnAttentePaiement == true &&
      _activeReverseSearch?.residenceSelectionnee == widget.residenceModel.id;

  /// Une AUTRE résidence est verrouillée : bloque "Réserver" ici tant que ce
  /// n'est pas réglé.
  bool get _isLockedElsewhere =>
      _activeReverseSearch?.statusEnum.isSelectionEnAttentePaiement == true &&
      _activeReverseSearch?.residenceSelectionnee != widget.residenceModel.id;

  /// Résidence atteinte depuis une proposition de recherche inversée, pas
  /// encore sélectionnée : le premier tap sur "Payer" la verrouille.
  bool get _isImmediateBookingEligible =>
      widget.isImmediateBooking && widget.reverseSearchId != null;

  @override
  void initState() {
    super.initState();
    // Toujours revérifié depuis l'API (jamais déduit d'un état local qui
    // pourrait dater d'un aller-retour sur une autre page) : c'est ce qui
    // garantit un rendu cohérent quel que soit le chemin de navigation.
    unawaited(_refreshActiveReverseSearch());
    _initSocketListener();
  }

  void _initSocketListener() {
    try {
      final socketService = getIt<ReverseSearchSocketService>();
      _socketStatusSub = socketService.onStatus.listen((status) {
        if (status == 'selection_expiree' || status == 'annulee') {
          unawaited(_refreshActiveReverseSearch());
        }
      });
    } catch (_) {}
  }

  Future<void> _refreshActiveReverseSearch() async {
    try {
      final active = await getIt<ReverseSearchRepository>().getActiveSearch();
      if (mounted) setState(() => _activeReverseSearch = active);
    } catch (_) {}
  }

  /// Déclenché quand le compte à rebours du bandeau atteint zéro : passé les
  /// 10 minutes, la sélection est de toute façon caduque, on remet l'UI à
  /// l'état normal directement plutôt que d'attendre une confirmation
  /// serveur.
  void _onSelectionCountdownExpired() {
    if (mounted) setState(() => _activeReverseSearch = null);
  }

  void _payForThisResidence(BuildContext context) {
    final reverseSearchId = widget.reverseSearchId;
    if (reverseSearchId == null) return;

    final price =
        (widget.reverseSearchPrice ?? widget.residenceModel.prixReservation)
            .toDouble();

    getIt<AnalyticsService>().logResidenceBookingCtaTapped(
      residenceId: widget.residenceModel.id,
      residenceName: widget.residenceModel.nom,
      price: price,
    );

    void execute() => unawaited(_lockAndPay(context, reverseSearchId, price));

    if (_sessionManager.currentUser == null) {
      getIt<AuthRedirectService>().set((
        popUntilRouteName: ResidencePage.name,
        callback: execute,
      ));
      context.pushNamed(AuthenticationPage.name);
    } else {
      execute();
    }
  }

  Future<void> _lockAndPay(
    BuildContext context,
    String reverseSearchId,
    double price,
  ) async {
    setState(() => _isLocking = true);
    try {
      // Verrouille la résidence pour 10 minutes avant paiement
      // (POST /reverse-searches/action/select/:id).
      await getIt<ReverseSearchRepository>()
          .selectResidence(reverseSearchId, widget.residenceModel.id);
      await _refreshActiveReverseSearch();
      if (!mounted || !context.mounted) return;
      context.pushNamed(
        OperatorsSelectorPage.name,
        extra: PaymentPageAdapter(
          itemId: reverseSearchId,
          collection: ProductType.reverse_searches.name,
          amount: price.toInt(),
        ),
      );
    } catch (e) {
      ToastUtils.showError(
          description: e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLocking = false);
    }
  }

  Future<void> _cancelActiveReverseSearch() async {
    final item = _activeReverseSearch;
    if (item == null) return;
    try {
      await getIt<ReverseSearchRepository>().cancelSearch(item.id);
      ToastUtils.showSuccess(description: 'Recherche annulée');
      if (mounted) setState(() => _activeReverseSearch = null);
    } catch (e) {
      ToastUtils.showError(description: 'Erreur lors de l\'annulation');
    }
  }

  @override
  void dispose() {
    _socketStatusSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showPayBar = _isThisResidenceLocked ||
        (_isImmediateBookingEligible && !_isLockedElsewhere);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isThisResidenceLocked || _isLockedElsewhere)
          PendingReverseSearchBanner(
            selectionExpireAt: _activeReverseSearch!.selectionExpireAt,
            onTap: () => ReverseSearchNavigation.resumeToPayment(
                context, _activeReverseSearch!),
            onCancel: _cancelActiveReverseSearch,
            onExpired: () => _onSelectionCountdownExpired(),
          ),
        if (showPayBar)
          ReverseSearchPayBar(
            price: (widget.reverseSearchPrice ??
                    widget.residenceModel.prixReservation)
                .toDouble(),
            isLoading: _isLocking,
            onTap: () {
              if (_isThisResidenceLocked) {
                ReverseSearchNavigation.resumeToPayment(
                    context, _activeReverseSearch!);
              } else {
                _payForThisResidence(context);
              }
            },
          )
        else
          StandardBookingBottomBar(
            residenceModel: widget.residenceModel,
            lockedElsewhere: _isLockedElsewhere ? _activeReverseSearch : null,
            onLockCancelled: () =>
                setState(() => _activeReverseSearch = null),
          ),
      ],
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// BARRE : Réservation standard (Flux classique avec formulaire)
/// ─────────────────────────────────────────────────────────────────────────────
class StandardBookingBottomBar extends StatelessWidget {
  const StandardBookingBottomBar({
    super.key,
    required this.residenceModel,
    this.lockedElsewhere,
    this.onLockCancelled,
  });

  final ResidenceModel residenceModel;

  /// Recherche inversée verrouillée sur une autre résidence : bloque
  /// "Réserver" tant que l'utilisateur n'a pas annulé ou payé cette
  /// sélection.
  final ReverseSearchItem? lockedElsewhere;
  final VoidCallback? onLockCancelled;

  @override
  Widget build(BuildContext context) {
    final sessionManager = getIt<SessionManager>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        left: appPadding,
        right: appPadding,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Row(
        children: [
          // ── Prix standard ──
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: CurrencyFormatter()
                            .format(residenceModel.prixReservation.toString()),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF222222),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const TextSpan(
                        text: ' F',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF222222),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'par nuitée',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          // ── Bouton "Réserver" ──
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () => _handleStandardBooking(context, sessionManager),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              child: const Text('Réserver'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleStandardBooking(
    BuildContext context,
    SessionManager sessionManager,
  ) {
    if (lockedElsewhere != null) {
      _showLockedElsewhereDialog(context, lockedElsewhere!);
      return;
    }

    getIt<AnalyticsService>().logResidenceBookingCtaTapped(
      residenceId: residenceModel.id,
      residenceName: residenceModel.nom,
      price: residenceModel.prixReservation.toDouble(),
    );

    void openBookingForm() {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => BookingFormularAction(residenceModel: residenceModel),
        ),
      );
    }

    if (sessionManager.currentUser == null) {
      getIt<AuthRedirectService>().set((
        popUntilRouteName: ResidencePage.name,
        callback: openBookingForm,
      ));
      context.pushNamed(AuthenticationPage.name);
    } else {
      openBookingForm();
    }
  }

  void _showLockedElsewhereDialog(
    BuildContext context,
    ReverseSearchItem item,
  ) {
    AppDialog.show(
      title: 'Sélection en attente de paiement',
      description: 'Tu as déjà une résidence sélectionnée en attente de '
          'paiement. Termine ou annule cette sélection avant d\'en réserver '
          'une autre.',
      primaryButtonText: 'Continuer le paiement',
      secondButtonText: 'Annuler cette sélection',
      onPrimary: () => ReverseSearchNavigation.resumeToPayment(context, item),
      onSecond: () async {
        try {
          await getIt<ReverseSearchRepository>().cancelSearch(item.id);
          ToastUtils.showSuccess(description: 'Recherche annulée');
          onLockCancelled?.call();
        } catch (e) {
          ToastUtils.showError(description: 'Erreur lors de l\'annulation');
        }
      },
    );
  }
}
