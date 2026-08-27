import 'package:flutter/material.dart';
import 'package:immoplus/app/features/payment_module/components/moov/moov_page.dart';
import 'package:immoplus/app/features/payment_module/components/mtn/mtn_page.dart';
import 'package:immoplus/app/features/payment_module/components/orange/orange_page.dart';
import 'package:immoplus/app/features/payment_module/components/stripe/stripe_page.dart';
import 'package:immoplus/app/features/payment_module/components/wave/wave_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/features/payment_module/utils/utils.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';

class PaiementStatusPage extends StatefulWidget {
  static String name = 'paiement_status_page';
  static bool isActive = false;
  final PaymentPageAdapter paymentPageAdapter;
  const PaiementStatusPage({super.key, required this.paymentPageAdapter});

  @override
  State<PaiementStatusPage> createState() => _PaiementStatusPageState();
}

class _PaiementStatusPageState extends State<PaiementStatusPage> {
  @override
  void initState() {
    super.initState();
    PaiementStatusPage.isActive = true;
  }

  @override
  void dispose() {
    PaiementStatusPage.isActive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Pas d'AppBar pour Stripe : StripeCardPage a son propre bouton ✕
    // et StripeResultPage ne doit pas avoir de retour arrière.
    final isStripe = OrderPaymentController.selectedOperator.value ==
        OPERATOR_NAME.stripe.apiValue;

    return Scaffold(
      appBar: isStripe ? null : AppBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          if (OrderPaymentController.selectedOperator.value ==
              OPERATOR_NAME.Orange.name.toLowerCase())
            OrangePage(
              amount: widget.paymentPageAdapter.amount,
              orderID: widget.paymentPageAdapter.itemId,
              productType: widget.paymentPageAdapter.collection,
              extra: widget.paymentPageAdapter.extra,
            )
          else if (OrderPaymentController.selectedOperator.value ==
              OPERATOR_NAME.Wave.name.toLowerCase())
            WavePage(
              amount: widget.paymentPageAdapter.amount,
              orderID: widget.paymentPageAdapter.itemId,
              productType: widget.paymentPageAdapter.collection,
              extra: widget.paymentPageAdapter.extra,
            )
          else if (OrderPaymentController.selectedOperator.value ==
              OPERATOR_NAME.Moov.name.toLowerCase())
            MoovPage(
              amount: widget.paymentPageAdapter.amount,
              orderID: widget.paymentPageAdapter.itemId,
              productType: widget.paymentPageAdapter.collection,
              extra: widget.paymentPageAdapter.extra,
            )
          else if (OrderPaymentController.selectedOperator.value ==
              OPERATOR_NAME.MTN.name.toLowerCase())
            MtnPage(
              amount: widget.paymentPageAdapter.amount,
              orderID: widget.paymentPageAdapter.itemId,
              productType: widget.paymentPageAdapter.collection,
              extra: widget.paymentPageAdapter.extra,
            )
          else if (OrderPaymentController.selectedOperator.value ==
              OPERATOR_NAME.stripe.apiValue)
            StripePage(
              amount: widget.paymentPageAdapter.amount,
              orderID: widget.paymentPageAdapter.itemId,
              productType: widget.paymentPageAdapter.collection,
              extra: widget.paymentPageAdapter.extra,
            ),
        ]),
      ),
    );
  }
}
