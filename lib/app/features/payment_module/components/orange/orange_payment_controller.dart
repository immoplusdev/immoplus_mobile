import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';

enum OrangePaymentStep {
  phoneNumber,
  otpValidator,
}

class OrangePaymentController extends ChangeNotifier {
  OrangePaymentStep _currentStep = OrangePaymentStep.phoneNumber;
  PaymentItentData? _paymentIntentData;
  String? _phoneNumber;

  OrangePaymentStep get currentStep => _currentStep;
  PaymentItentData? get paymentIntentData => _paymentIntentData;
  String? get phoneNumber => _phoneNumber;

  void goToOtpValidator(PaymentItentData data, [String? number]) {
    _paymentIntentData = data;
    _phoneNumber = number;
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
    _phoneNumber = null;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}
