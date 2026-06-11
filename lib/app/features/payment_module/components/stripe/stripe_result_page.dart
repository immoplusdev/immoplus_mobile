import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/app_colors.dart';
import 'package:immoplus/app/utils/lottie_assets.dart';

class StripeResultPage extends StatelessWidget {
  const StripeResultPage({
    super.key,
    required this.paymentIntentData,
  });

  final PaymentItentData paymentIntentData;

  @override
  Widget build(BuildContext context) {
    final paymentData = PaymentData.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 200, child: LottieAssets().success),
            Text(
              "Paiement validé",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Gap(10),
            const Text(
              "Votre paiement par carte a été validé avec succès",
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            TextButton.icon(
              iconAlignment: IconAlignment.end,
              icon: Icon(
                FontAwesomeIcons.circleArrowRight,
                color: AppColors.primary,
                size: 20,
              ),
              onPressed: () {
                AppRouter.router.go(
                  "/payment/${paymentData?.productType}/${paymentData?.orderID}",
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              label: Text(
                "Voir les détails de la réservation",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
