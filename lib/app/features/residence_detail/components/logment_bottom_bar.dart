import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/constants.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/auth_redirect_service.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/features/booking/booking_formular_action.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/currency_formatter.dart';

class LogmentBottomBar extends StatelessWidget {
  LogmentBottomBar({super.key, required this.residenceModel});
  final ResidenceModel residenceModel;
  final sessionManager = getIt<SessionManager>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: appPadding).copyWith(top: 10),
      child: Row(
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text:
                  "${CurrencyFormatter().format(residenceModel.prixReservation.toString())} F",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            TextSpan(
              text: '/nuitée',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                  ),
            )
          ])),
          Gap(10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (sessionManager.currentUser == null) {
                  getIt<AuthRedirectService>().set((
                    popUntilRouteName: ResidencePage.name,
                    callback: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => BookingFormularAction(
                                residenceModel: residenceModel),
                          ),
                        ),
                  ));
                  // 2. Naviguer sans extra
                  context.pushNamed(AuthenticationPage.name);
                } else {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => BookingFormularAction(
                              residenceModel: residenceModel)));
                }
              },
              child: FittedBox(child: const Text('Réserver')),
            ),
          ),
        ],
      ),
    );
  }
}
