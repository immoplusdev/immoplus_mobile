import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';

enum OrangePaymentStep {
  phoneNumber,
  otpValidator,
  validator,
}

class OrangePaymentController extends ChangeNotifier {
  OrangePaymentStep _currentStep = OrangePaymentStep.phoneNumber;
  PaymentItentData? _paymentIntentData;
  String? _phoneNumber;

  OrangePaymentStep get currentStep => _currentStep;
  PaymentItentData? get paymentIntentData => _paymentIntentData;
  String? get phoneNumber => _phoneNumber;

  void goToOtpValidator(String number) {
    _phoneNumber = number;
    _currentStep = OrangePaymentStep.otpValidator;
    notifyListeners();
  }

  void goToValidator(PaymentItentData data) {
    _paymentIntentData = data;
    _currentStep = OrangePaymentStep.validator;
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
