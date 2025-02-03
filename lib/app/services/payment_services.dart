// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

// class PaymentServices {
//   static initPayment({
//     required BuildContext context,
//     required String number,
//     required String productType,
//     required String orderID,
//     required Function(PaymentIntentModel p) onSuccess,
//     required Function() onFailed,
//   }) async {
//     try {
//       PaymentIntentModel paymentIntentModel =
//           await Repository<PaymentIntentModel>(PaymentIntentModel()).fetchData(
//               requestInfo: RequestInfo(
//                   method: METHOD.POST,
//                   path: RequestPath.createPaymentIntent,
//                   data: {
//                     "product_type": productType,
//                     "item_id": orderID,
//                     "payment_method":
//                         OrderPaymentController.selectedOperator.value,
//                     "msisdn": number.trim(),
//                   }),
//               context: context) as PaymentIntentModel;

//       if (paymentIntentModel.amount == 0 ||
//           paymentIntentModel.itemId!.isEmpty) {
//         onFailed();
//       } else if (paymentIntentModel.itemId!.isNotEmpty) {
//         log("SUCCESS");
//         inspect(paymentIntentModel);
//         onSuccess(paymentIntentModel);
//       }
//     } catch (e) {
//       log(e.toString(), name: 'ERROR INIT');
//       EasyLoading.showToast("Une erreur s'est produite");
//       onFailed();
//     }
//   }

//   static authenticatePayment({
//     required String otp,
//     required String orderId,
//     required String productType,
//     required BuildContext context,
//     required Function() onSuccess,
//     required Function() onFailed,
//   }) async {
//     //print(UserModel.singleton.accessToken);_formKey.currentState!.validate()

//     try {
//       EasyLoading.show(status: 'Vérification en cours...');
//       Response? rp = await ApiProvider(context: context).request(RequestInfo(
//           method: METHOD.POST,
//           path: RequestPath.authentificatePayment,
//           data: {
//             "otp": otp,
//             "item_id": orderId,
//             "product_type": productType,
//           }));

//       if (rp!.statusCode != 200) {
//         EasyLoading.showToast(rp.data['errors'][0]["message"],
//             toastPosition: EasyLoadingToastPosition.bottom,
//             duration: Duration(seconds: 5));
//         onFailed();
//       } else {
//         log("SUCCESS");

//         EasyLoading.dismiss();
//         onSuccess();
//       }
//     } catch (e) {
//       EasyLoading.showToast(
//         "La tentative d'authentification a échoué. Assurez-vous que le code OTP est correct.",
//       );
//       onFailed();
//     }
//   }
// }
