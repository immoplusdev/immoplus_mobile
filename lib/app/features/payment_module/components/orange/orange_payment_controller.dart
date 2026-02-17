import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';

enum OrangePaymentStep {
  phoneNumber,
  otpValidator,
}

class OrangePaymentController extends ChangeNotifier {
  OrangePaymentStep _currentStep = OrangePaymentStep.phoneNumber;
  PaymentItentData? _paymentIntentData;

  OrangePaymentStep get currentStep => _currentStep;
  PaymentItentData? get paymentIntentData => _paymentIntentData;

  void goToOtpValidator(PaymentItentData data) {
    _paymentIntentData = data;
    _currentStep = OrangePaymentStep.otpValidator;
    notifyListeners();
  }

  void goToPhoneNumber() {
    _currentStep = OrangePaymentStep.phoneNumber;
    _paymentIntentData = null;
    notifyListeners();
  }

  void reset() {
    _currentStep = OrangePaymentStep.phoneNumber;
    _paymentIntentData = null;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}
