import 'package:flutter/material.dart';
import 'package:immoplus/app/features/payment_module/components/moov/moov_payment_controller.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'package:immoplus/app/features/payment_module/components/moov/moov_phone_number_page.dart';
import 'package:immoplus/app/features/payment_module/components/moov/moov_validator_page.dart';

class MoovPage extends StatefulWidget {
  const MoovPage({
    super.key,
    required this.productType,
    required this.orderID,
    required this.amount,
  });

  final String productType;
  final String orderID;
  final int amount;

  @override
  State<MoovPage> createState() => _MoovPageState();
}

class _MoovPageState extends State<MoovPage> {
  late final MoovPaymentController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MoovPaymentController();
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
              height: _controller.currentStep == MoovPaymentStep.phoneNumber
                  ? 300 + MediaQuery.of(context).viewInsets.bottom
                  : 500 + MediaQuery.of(context).viewInsets.bottom,
              child: _controller.currentStep == MoovPaymentStep.phoneNumber
                  ? MoovNumberPage(controller: _controller)
                  : MoovOptValidatorPage(
                      controller: _controller,
                      paymentIntentModel: _controller.paymentIntentData!,
                    ),
            ),
          );
        },
      ),
    );
  }
}
