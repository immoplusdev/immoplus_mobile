import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../models/remote/payment/payment_authenticate_body.dart';
import '../models/remote/payment/payment_intent_body.dart';
import '../models/remote/payment/payment_itent_model.dart';
import '../models/remote/payment/payments_model_collection.dart';

part 'payment_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class PaymentProvider {
  factory PaymentProvider(Dio dio, {String baseUrl}) = _PaymentProvider;

  @POST("/payments/action/create-payment-intent")
  Future<PaymentItentModel> intentPayment(@Body() PaymentIntentBody body);

  @POST("/payments/action/authenticate-payment-intent")
  Future<PaymentItentModel> authenticate(@Body() PaymentAuthenticateBody body);

  @GET("/payments/{id}")
  Future<PaymentItentModel> getPayment(@Path() String id);

  @GET("/payments")
  Future<PaymentsModelCollection> getPayments(
    @Query("_search") String? search,
    @Query("_page") int page,
    @Query("_per_page") int perPage,
    @Query("_order_by") String? orderBy,
    @Query("_order_dir") String? orderDir,
  );
}
