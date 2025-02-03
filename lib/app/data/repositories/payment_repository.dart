import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/exceptions/request_response_exeption.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_authenticate_body.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_intent_body.dart';
import 'package:immoplus/app/data/models/remote/payment/payments_model_collection.dart';
import 'package:immoplus/app/data/providers/payment_provider.dart';

import '../models/remote/payment/payment_itent_model.dart';

class PaymentRepository {
  final dioClient = getIt<Dio>();

  Future<PaymentItentModel> intent({required PaymentIntentBody body}) async {
    try {
      final response = await PaymentProvider(dioClient).intentPayment(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  Future<PaymentItentModel> authenticate(
      {required PaymentAuthenticateBody body}) async {
    try {
      final response = await PaymentProvider(dioClient).authenticate(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  Future<PaymentItentModel> getPayment(String id) async {
    try {
      final response = await PaymentProvider(dioClient).getPayment(id);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  Future<PaymentsModelCollection> getPayments({
    required int page,
    required int perPage,
    String? orderBy,
    String? orderDir,
    String? search,
  }) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response = await PaymentProvider(dioClient)
          .getPayments(search, page, perPage, orderBy, orderDir);

      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }
}
