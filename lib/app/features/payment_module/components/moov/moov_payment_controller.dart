import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';

enum MoovPaymentStep {
  phoneNumber,
  validator,
}

class MoovPaymentController extends ChangeNotifier {
  MoovPaymentStep _currentStep = MoovPaymentStep.phoneNumber;
  PaymentItentData? _paymentIntentData;

  MoovPaymentStep get currentStep => _currentStep;
  PaymentItentData? get paymentIntentData => _paymentIntentData;

  void goToValidator(PaymentItentData data) {
    _paymentIntentData = data;
    _currentStep = MoovPaymentStep.validator;
    notifyListeners();
  }

  void goToPhoneNumber() {
    _currentStep = MoovPaymentStep.phoneNumber;
    _paymentIntentData = null;
    notifyListeners();
  }

  void reset() {
    _currentStep = MoovPaymentStep.phoneNumber;
    _paymentIntentData = null;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}
