import 'package:flutter/material.dart';
import 'package:immoplus/app/features/payment_module/components/orange/orange_payment_controller.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'package:immoplus/app/features/payment_module/components/orange/orange_phone_number_page.dart';
import 'package:immoplus/app/features/payment_module/components/orange/orange_otp_validator_page.dart';

class OrangePage extends StatefulWidget {
  const OrangePage({
    super.key,
    required this.productType,
    required this.orderID,
    required this.amount,
    this.extra,
  });

  final String productType;
  final String orderID;
  final int amount;
  final Object? extra;

  @override
  State<OrangePage> createState() => _OrangePageState();
}

class _OrangePageState extends State<OrangePage> {
  late final OrangePaymentController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OrangePaymentController();
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
      extra: widget.extra,
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
              child: _controller.currentStep == OrangePaymentStep.phoneNumber
                  ? OrangePhoneNumberPage(controller: _controller)
                  : OrangeOptValidatorPage(
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
