import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus/app/features/payment_module/components/wave/wave_validator_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_data.dart';
import 'wave_phone_number_page.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';

enum WavePaymentStep {
  phoneNumber,
  validator,
}

class WavePaymentController extends ChangeNotifier {
  WavePaymentStep _currentStep = WavePaymentStep.phoneNumber;
  PaymentItentData? _paymentIntentData;

  WavePaymentStep get currentStep => _currentStep;
  PaymentItentData? get paymentIntentData => _paymentIntentData;

  void goToValidator(PaymentItentData data) {
    _paymentIntentData = data;
    _currentStep = WavePaymentStep.validator;
    notifyListeners();
  }

  void goToPhoneNumber() {
    _currentStep = WavePaymentStep.phoneNumber;
    _paymentIntentData = null;
    notifyListeners();
  }

  void reset() {
    _currentStep = WavePaymentStep.phoneNumber;
    _paymentIntentData = null;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}

class WavePage extends StatefulWidget {
  const WavePage({
    super.key,
    required this.productType,
    required this.orderID,
    required this.amount,
  });

  final String productType;
  final String orderID;
  final int amount;

  @override
  State<WavePage> createState() => _WavePageState();
}

class _WavePageState extends State<WavePage> {
  late final WavePaymentController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WavePaymentController();
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
              height: _controller.currentStep == WavePaymentStep.phoneNumber
                  ? 300 + MediaQuery.of(context).viewInsets.bottom
                  : 500 + MediaQuery.of(context).viewInsets.bottom,
              child: _controller.currentStep == WavePaymentStep.phoneNumber
                  ? WaveNumberPage(controller: _controller)
                  : WaveValidatorPage(
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
