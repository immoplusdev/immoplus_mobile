import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';

enum MtnPaymentStep {
  phoneNumber,
  validator,
}

class MtnPaymentController extends ChangeNotifier {
  MtnPaymentStep _currentStep = MtnPaymentStep.phoneNumber;
  PaymentItentData? _paymentIntentData;

  MtnPaymentStep get currentStep => _currentStep;
  PaymentItentData? get paymentIntentData => _paymentIntentData;

  void goToValidator(PaymentItentData data) {
    _paymentIntentData = data;
    _currentStep = MtnPaymentStep.validator;
    notifyListeners();
  }

  void goToPhoneNumber() {
    _currentStep = MtnPaymentStep.phoneNumber;
    _paymentIntentData = null;
    notifyListeners();
  }

  void reset() {
    _currentStep = MtnPaymentStep.phoneNumber;
    _paymentIntentData = null;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}
