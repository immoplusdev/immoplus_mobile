import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/features/payment_module/components/stripe/stripe_result_page.dart';
import 'package:immoplus/app/utils/app_colors.dart';

class StripeResultRoute extends StatelessWidget {
  static const String path = '/stripe-result';
  static const String name = 'stripe_result';

  final PaymentItentData paymentIntentData;

  const StripeResultRoute({super.key, required this.paymentIntentData});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.scafold,
        body: SafeArea(
          child: StripeResultPage(paymentIntentData: paymentIntentData),
        ),
      ),
    );
  }
}
