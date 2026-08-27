import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_intent_body.dart';
import 'package:immoplus/app/data/repositories/payment_repository.dart';
import 'package:immoplus/app/features/fast-track-book/reservation_engagement.dart';
import 'package:immoplus/app/features/payment_module/components/stripe/stripe_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/utils.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:immoplus/app/widgets/custom_button.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';

class StripeCardPage extends StatefulWidget {
  const StripeCardPage({super.key, required this.controller});

  final StripePaymentController controller;

  @override
  State<StripeCardPage> createState() => _StripeCardPageState();
}

class _StripeCardPageState extends State<StripeCardPage> {
  bool _isLoading = false;

  Future<void> _onPay(PaymentData paymentData) async {
    setState(() => _isLoading = true);

    try {
      // 1. Créer le payment intent côté backend
      final model = await PaymentRepository().intent(
        body: PaymentIntentBody(
          collection: paymentData.productType,
          itemId: paymentData.orderID,
          paymentMethod: OrderPaymentController.selectedOperator.value,
          paymentCredentials: '',
        ),
      );

      final clientSecret = model.data.stripeClientSecret ?? '';

      if (clientSecret.isEmpty) {
        EasyLoading.showToast("Impossible d'initialiser le paiement.");
        setState(() => _isLoading = false);
        return;
      }

      // 2. Initialiser la payment sheet Stripe
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'ImmoPlus',
          style: ThemeMode.light,
        ),
      );

      // 3. Stopper le polling avant que Stripe prenne le premier plan,
      //    sinon les ticks accumulés se déclenchent au retour et causent des 504.
      ReservationEngagementFrame.onPaymentCompleted();

      // 4. Afficher la payment sheet (Stripe gère carte, Apple Pay, Google Pay, 3DS)
      await Stripe.instance.presentPaymentSheet();

      // 5. Succès → afficher résultat
      if (!mounted) return;
      widget.controller.goToResult(model.data);
    } on StripeException catch (e) {
      log('StripeException: ${e.error.localizedMessage}', name: 'STRIPE');
      if (e.error.code != FailureCode.Canceled) {
        EasyLoading.showToast(
          e.error.localizedMessage ?? "Le paiement a échoué.",
        );
      }
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      log('Error: $e', name: 'STRIPE');
      EasyLoading.showToast("Une erreur s'est produite.");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentData = PaymentData.of(context);

    if (paymentData == null) {
      return const Center(
          child: Text('Erreur: Données de paiement manquantes'));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              foregroundImage: NetworkImage(
                OrderPaymentController.selectedOperator.logo,
              ),
            ),
            title: Text(
              OrderPaymentController.selectedOperator.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            trailing: IconButton(
              icon: const Icon(
                CupertinoIcons.clear_circled_solid,
                color: Colors.black,
              ),
              onPressed: () {
                AppDialog.confirm(
                  context: context,
                  content: "Voulez vous annuler l'opération ?",
                  rollback: () {
                    AppRouter.router.pop();
                    AppRouter.router.pop();
                  },
                );
              },
            ),
          ),
          ListTile(
            tileColor: Colors.white,
            leading:
                const FaIcon(FontAwesomeIcons.moneyBill, color: Colors.green),
            title: Text(Utils.formatCurrency(paymentData.amount)),
            titleTextStyle: Theme.of(context).textTheme.headlineSmall,
          ),
          const Divider(),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.creditCard.data,
                size: 13,
                color: Color(0xFF635BFF),
              ),
              const Gap(8),
              Text(
                "Carte · Apple Pay · Google Pay · 3DS",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
          const Gap(16),
          CustomButtom(
            isLoading: _isLoading,
            clickable: !_isLoading,
            onClick: () => _onPay(paymentData),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.lock, size: 13, color: Colors.white),
                Gap(8),
                Text(
                  "Payer par carte",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
