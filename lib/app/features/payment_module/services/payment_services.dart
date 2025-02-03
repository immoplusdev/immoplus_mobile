import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_authenticate_body.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_intent_body.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_model.dart';
import 'package:immoplus/app/data/repositories/payment_repository.dart';
import 'package:immoplus/app/widgets/operator_payment.dart';

class PaymentServices {
  static Future initPayment({
    required BuildContext context,
    required String number,
    required String collection,
    required String itemID,
    required Function(PaymentItentData p) onSuccess,
    required Function() onFailed,
  }) async {
    try {
      PaymentItentModel paymentIntentModel = await PaymentRepository().intent(
          body: PaymentIntentBody(
        collection: collection,
        itemId: itemID,
        paymentMethod: OrderPaymentController.selectedOperator.value,
        paymentCredentials: number.trim(),
      ));

      if (paymentIntentModel.data.amount == 0 ||
          paymentIntentModel.data.itemId.isEmpty) {
        onFailed();
      } else if (paymentIntentModel.data.itemId.isNotEmpty) {
        log("SUCCESS");
        inspect(paymentIntentModel);
        onSuccess(paymentIntentModel.data);
      }
    } catch (e) {
      log(e.toString(), name: 'ERROR INIT');
      EasyLoading.showToast("Une erreur s'est produite");
      onFailed();
    }
  }

  static Future authenticatePayment({
    required String otp,
    required String itemId,
    required String collection,
    required BuildContext context,
    required Function() onSuccess,
    required Function() onFailed,
  }) async {
    //print(UserModel.singleton.accessToken);_formKey.currentState!.validate()

    try {
      EasyLoading.show(status: 'Vérification en cours...');
      await PaymentRepository().authenticate(
          body: PaymentAuthenticateBody(
        collection: collection,
        itemId: itemId,
        otp: otp,
      ));

      log("SUCCESS");

      EasyLoading.dismiss();
      onSuccess();
    } catch (e) {
      EasyLoading.showToast(
        "La tentative d'authentification a échoué. Assurez-vous que le code OTP est correct.",
      );
      onFailed();
    }
  }
}
