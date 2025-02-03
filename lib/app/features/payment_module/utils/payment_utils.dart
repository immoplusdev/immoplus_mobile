import 'dart:developer';

import 'package:immoplus/app/data/models/remote/payment/operator_provider_model.dart';

class PaymentUtils {
  static final phoneNumberRegexp = RegExp("^(99|0[157])[0-9]{8}");
  static final orangeNumberRegexp = RegExp("^07[0-9]{8}");
  static final mtnNumberRegexp = RegExp("^05[0-9]{8}");
  static final moovNumberRegexp = RegExp("^01[0-9]{8}");
  static OperatorProviderModel selectedValue = const OperatorProviderModel(
      id: "cash", name: "Cash", country: "CI", method: "cash", currency: "XOF");
  static String? numberValidator(
      {required String number, required String operatorName}) {
    log(operatorName);
    log(number);
    print(_checkPhoneOperator(operator: operatorName, numner: number));
    if (number.isEmpty || number.toString().isEmpty) {
      return 'veillez entrer votre numéro';
    } else if (!_checkPhoneOperator(operator: operatorName, numner: number)) {
      return 'Veuillez entrer un numéro correct.';
    }

    return null;
  }

  static bool _checkPhoneOperator(
      {required String operator, required String numner}) {
    return switch (operator) {
      'orange' => orangeNumberRegexp.hasMatch(numner),
      'moov' => moovNumberRegexp.hasMatch(numner),
      'mtn' => mtnNumberRegexp.hasMatch(numner),
      'wave' => phoneNumberRegexp.hasMatch(numner),
      _ => false,
    };
  }
}
