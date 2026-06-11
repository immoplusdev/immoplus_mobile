import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/features/payment_module/components/stripe/stripe_card_page.dart';
import 'package:immoplus/app/features/payment_module/components/stripe/stripe_result_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';

enum StripePaymentStep { cardEntry, result }

class StripePaymentController extends ChangeNotifier {
  StripePaymentStep _currentStep = StripePaymentStep.cardEntry;
  PaymentItentData? _paymentIntentData;

  StripePaymentStep get currentStep => _currentStep;
  PaymentItentData? get paymentIntentData => _paymentIntentData;

  void goToResult(PaymentItentData data) {
    _paymentIntentData = data;
    _currentStep = StripePaymentStep.result;
    notifyListeners();
  }

  void reset() {
    _currentStep = StripePaymentStep.cardEntry;
    _paymentIntentData = null;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}

class StripePage extends StatefulWidget {
  const StripePage({
    super.key,
    required this.productType,
    required this.orderID,
    required this.amount,
  });

  final String productType;
  final String orderID;
  final int amount;

  @override
  State<StripePage> createState() => _StripePageState();
}

class _StripePageState extends State<StripePage> {
  late final StripePaymentController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StripePaymentController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaymentData(
      productType: widget.productType,
      orderID: widget.orderID,
      amount: widget.amount,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.3, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: SizedBox(
              key: ValueKey(_controller.currentStep),
              height: _controller.currentStep == StripePaymentStep.cardEntry
                  ? 280 + MediaQuery.of(context).viewInsets.bottom
                  : 400 + MediaQuery.of(context).viewInsets.bottom,
              child: _controller.currentStep == StripePaymentStep.cardEntry
                  ? StripeCardPage(controller: _controller)
                  : StripeResultPage(
                      paymentIntentData: _controller.paymentIntentData!,
                    ),
            ),
          );
        },
      ),
    );
  }
}
