import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/logic/request_state.dart';

class PaymentCubit extends Cubit<RequestState> {
  PaymentCubit() : super(const REQUEST_INITIAL());

  // @override
  // getOperators({required BuildContext context}) async {
  //   emit(PendingState());
  //   List<OperatorProviderModel> operator =
  //       await Repository<OperatorProviderModel>(OperatorProviderModel())
  //           .fetchListData(
  //               requestInfo: PaymentAdapter().getOperators(),
  //               context: context) as List<OperatorProviderModel>;
  //   emit(FinishState<List<OperatorProviderModel>>(data: operator));
  //}

  // authenticatePayment(
  //     {required String otp,
  //     required String orderId,
  //     required String productType,
  //     required BuildContext context}) async {
  //   emit(PendingState<PaymentState>());

  //   //print(UserModel.singleton.accessToken);_formKey.currentState!.validate()

  //   try {
  //     EasyLoading.show(status: 'Vérification en cours...');
  //     Response? rp = await ApiProvider(context: context).request(RequestInfo(
  //         method: METHOD.POST,
  //         path: RequestPath.authentificatePayment,
  //         data: {
  //           "otp": otp,
  //           "item_id": orderId,
  //           "product_type": productType,
  //         }));

  //     if (rp!.statusCode != 200) {
  //       EasyLoading.showToast(rp.data['errors'][0]["message"],
  //           toastPosition: EasyLoadingToastPosition.bottom,
  //           duration: Duration(seconds: 5));
  //       emit(InitialState());
  //     } else {
  //       //log("SUCCESS");
  //       EasyLoading.dismiss();
  //       emit(SuccessState());
  //     }
  //   } catch (e) {
  //     // EasyLoading.showToast(
  //     //     "La tentative d'authentification a échoué. Assurez-vous que le code OTP est correct.",
  //     //     toastPosition: EasyLoadingToastPosition.bottom);
  //     emit(InitialState());
  //   }
  // }

  init() {
    (const REQUEST_INITIAL());
  }

  // initPayment({
  //   required BuildContext context,
  //   required String number,
  //   required String productType,
  //   required String orderID,
  //   Future? onSuccess,
  // }) async {
  //   emit(PendingState<PaymentState>());
  //   try {
  //     PaymentIntentModel paymentIntentModel =
  //         await Repository<PaymentIntentModel>(PaymentIntentModel()).fetchData(
  //             requestInfo: RequestInfo(
  //                 method: METHOD.POST,
  //                 path: RequestPath.createPaymentIntent,
  //                 data: {
  //                   "product_type": productType,
  //                   "item_id": orderID,
  //                   "payment_method":
  //                       OrderPaymentController.selectedOperator.value,
  //                   "msisdn": number.trim(),
  //                 }),
  //             context: context) as PaymentIntentModel;
  //     if (paymentIntentModel.amount == 0) {
  //       emit(FinishState<Null>(data: null));
  //     } else {
  //       emit(InitialState());
  //       log("SUCCESS");
  //       // Navigator.push(
  //       //   context,
  //       //   MaterialPageRoute(
  //       //     builder: (context) => PaymentPage(
  //       //       orderModel: paymentIntentModel,
  //       //       number: number,
  //       //     ),
  //       //   ),
  //       // );
  //     }
  //   } catch (e) {
  //     emit(InitialState());
  //   }
  // }

  // getPaymentDetails(
  //     {required BuildContext context,
  //     required String productType,
  //     required itemId}) async {
  //   try {
  //     PaymentIntentModel paymentIntentModel =
  //         await Repository<PaymentIntentModel>(PaymentIntentModel()).fetchData(
  //             requestInfo: RequestInfo(
  //                 method: METHOD.GET,
  //                 path: "/api/payments/data",
  //                 queryParameters: {
  //                   "product_type": productType,
  //                   "item_id": itemId,
  //                 }),
  //             context: context) as PaymentIntentModel;
  //     if (paymentIntentModel.paymentStatus == PaymentStatus.successful.name) {
  //       emit(SuccessState());
  //     } else {
  //       emit(InitialState());
  //     }
  //   } catch (e) {
  //     emit(InitialState());
  //   }
  // }
}

class PaymentState {}
