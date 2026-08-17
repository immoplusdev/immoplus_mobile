import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/auth_redirect_service.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/features/booking/booking_formular_action.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';

class LogmentBottomBar extends StatelessWidget {
  LogmentBottomBar({
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
  final sessionManager = getIt<SessionManager>();

  @override
  Widget build(BuildContext context) {
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
          // ── Price section ──
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: CurrencyFormatter().format(isImmediateBooking
                            ? reverseSearchPrice.toString()
                            : residenceModel.prixReservation.toString()),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF222222),
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextSpan(
                        text: ' F',
                        style: const TextStyle(
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

          // ── CTA Button ──
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () => _handleReservation(context),
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
              child: Text(isImmediateBooking ? 'Payer' : 'Réserver'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleReservation(BuildContext context) {
    final finalPrice = isImmediateBooking
        ? (reverseSearchPrice ?? residenceModel.prixReservation).toDouble()
        : residenceModel.prixReservation.toDouble();

    getIt<AnalyticsService>().logResidenceBookingCtaTapped(
      residenceId: residenceModel.id,
      residenceName: residenceModel.nom,
      price: finalPrice,
    );

    void executeAction() {
      if (isImmediateBooking) {
        _payedTapped(context);
      } else {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) =>
                BookingFormularAction(residenceModel: residenceModel),
          ),
        );
      }
    }

    if (sessionManager.currentUser == null) {
      getIt<AuthRedirectService>().set((
        popUntilRouteName: ResidencePage.name,
        callback: executeAction,
      ));
      context.pushNamed(AuthenticationPage.name);
    } else {
      executeAction();
    }
  }

  _payedTapped(BuildContext context) {
    // TODO: Implement lock and payment flow for reverse search
    // example: context.read<ReverseSearchCubit>().lockResidence(reverseSearchId!, ...)
    // then context.pushNamed(PaymentScreen...)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Redirection vers le paiement...')),
    );
  }
}
