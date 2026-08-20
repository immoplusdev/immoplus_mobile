import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:immoplus/app/core/services/auth_redirect_service.dart';
import 'package:immoplus/app/core/services/reverse_search_socket_service.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/data/repositories/reverse_search_repository.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/features/booking/booking_formular_action.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';

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
  late bool _isImmediateBooking;

  @override
  void initState() {
    super.initState();
    _isImmediateBooking =
        widget.isImmediateBooking && widget.reverseSearchId != null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isImmediateBooking) {
      return ImmediatePaymentBottomBar(
        residenceModel: widget.residenceModel,
        reverseSearchId: widget.reverseSearchId!,
        reverseSearchPrice: widget.reverseSearchPrice,
        onExpired: () {
          if (mounted) {
            setState(() => _isImmediateBooking = false);
          }
        },
      );
    }

    return StandardBookingBottomBar(
      residenceModel: widget.residenceModel,
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// BARRE 1 : Réservation standard (Flux classique avec formulaire)
/// ─────────────────────────────────────────────────────────────────────────────
class StandardBookingBottomBar extends StatelessWidget {
  const StandardBookingBottomBar({
    super.key,
    required this.residenceModel,
  });

  final ResidenceModel residenceModel;

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
}

/// ─────────────────────────────────────────────────────────────────────────────
/// BARRE 2 : Paiement direct / Recherche Inversée (Timer 10 min + Verrou + Pay)
/// ─────────────────────────────────────────────────────────────────────────────
class ImmediatePaymentBottomBar extends StatefulWidget {
  const ImmediatePaymentBottomBar({
    super.key,
    required this.residenceModel,
    required this.reverseSearchId,
    this.reverseSearchPrice,
    required this.onExpired,
  });

  final ResidenceModel residenceModel;
  final String reverseSearchId;
  final double? reverseSearchPrice;
  final VoidCallback onExpired;

  @override
  State<ImmediatePaymentBottomBar> createState() =>
      _ImmediatePaymentBottomBarState();
}

class _ImmediatePaymentBottomBarState extends State<ImmediatePaymentBottomBar> {
  final sessionManager = getIt<SessionManager>();
  Timer? _countdownTimer;
  int _remainingSeconds = 10 * 60; // 10 minutes = 600s
  StreamSubscription<String>? _socketStatusSub;
  bool _isLocking = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _initSocketListener();
  }

  void _initSocketListener() {
    try {
      final socketService = getIt<ReverseSearchSocketService>();
      _socketStatusSub?.cancel();
      _socketStatusSub = socketService.onStatus.listen((status) {
        if (status == 'selection_expiree' || status == 'annulee') {
          _handleExpiration();
        }
      });
    } catch (_) {}
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _remainingSeconds = 10 * 60;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _handleExpiration();
      }
    });
  }

  void _handleExpiration() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _socketStatusSub?.cancel();
    _socketStatusSub = null;
    EasyLoading.showInfo("Le délai de réservation rapide a expiré.");
    widget.onExpired();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _socketStatusSub?.cancel();
    super.dispose();
  }

  String _formatRemainingTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final displayPrice =
        (widget.reverseSearchPrice ?? widget.residenceModel.prixReservation)
            .toDouble();

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
          // ── Prix issu de la proposition ──
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            CurrencyFormatter().format(displayPrice.toString()),
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
                  'par nuitée (offre spéciale)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          // ── Bouton "Payer (MM:SS)" avec loader ──
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _isLocking ? null : () => _handlePayment(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              child: _isLocking
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Payer (${_formatRemainingTime(_remainingSeconds)})',
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePayment(BuildContext context) {
    final finalPrice =
        (widget.reverseSearchPrice ?? widget.residenceModel.prixReservation)
            .toDouble();

    getIt<AnalyticsService>().logResidenceBookingCtaTapped(
      residenceId: widget.residenceModel.id,
      residenceName: widget.residenceModel.nom,
      price: finalPrice,
    );

    void executePayment() {
      _lockAndPay(context, finalPrice);
    }

    if (sessionManager.currentUser == null) {
      getIt<AuthRedirectService>().set((
        popUntilRouteName: ResidencePage.name,
        callback: executePayment,
      ));
      context.pushNamed(AuthenticationPage.name);
    } else {
      executePayment();
    }
  }

  Future<void> _lockAndPay(BuildContext context, double price) async {
    try {
      setState(() => _isLocking = true);
      EasyLoading.show(status: 'Sélection de la résidence...');

      final repository = getIt<ReverseSearchRepository>();
      // Étape 4b : Verrouille la résidence pour 10 minutes avant paiement (POST /reverse-searches/action/select/:id)
      await repository.selectResidence(
        widget.reverseSearchId,
        widget.residenceModel.id,
      );

      EasyLoading.dismiss();

      if (!context.mounted) return;

      // Étape 4c : Redirection vers le sélecteur d'opérateurs avec collection reverse_searches
      context.pushNamed(
        OperatorsSelectorPage.name,
        extra: PaymentPageAdapter(
          itemId: widget.reverseSearchId,
          collection: ProductType.reverse_searches.name,
          amount: price.toInt(),
        ),
      );
    } catch (e) {
      EasyLoading.showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isLocking = false);
      }
    }
  }
}
