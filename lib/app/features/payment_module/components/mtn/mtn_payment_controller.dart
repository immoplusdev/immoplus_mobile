import 'package:flutter/material.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';

enum MtnPaymentStep {
  phoneNumber,
  validator,
}

class MtnPaymentController extends ChangeNotifier {
  MtnPaymentStep _currentStep = MtnPaymentStep.phoneNumber;
  PaymentItentData? _paymentIntentData;
  String? _phoneNumber;

  MtnPaymentStep get currentStep => _currentStep;
  PaymentItentData? get paymentIntentData => _paymentIntentData;
  String? get phoneNumber => _phoneNumber;

  void goToValidator(PaymentItentData data, [String? number]) {
    _paymentIntentData = data;
    _phoneNumber = number;
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
    _phoneNumber = null;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}
