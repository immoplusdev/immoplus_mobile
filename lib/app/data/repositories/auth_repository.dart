import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/exceptions/request_response_exeption.dart';
import 'package:immoplus/app/data/models/auth/reset_password_body.dart';
import 'package:immoplus/app/data/models/auth/send_email_otp_body.dart';
import 'package:immoplus/app/data/models/auth/social_login_body.dart';
import 'package:immoplus/app/data/models/auth/update_user_response_model.dart';
import 'package:immoplus/app/data/models/auth/verify_email_otp.dart';
import 'package:immoplus/app/data/models/auth/verify_email_response.dart';
import 'package:immoplus/app/data/models/remote/configs/config_model.dart';
import 'package:retrofit/retrofit.dart';

import '../models/auth/account_creation_response.dart';
import '../models/auth/customer_registration_body.dart';
import '../models/auth/enterprise_registration_body.dart';
import '../models/auth/login_body_model.dart';
import '../models/auth/login_otp_body.dart';
import '../models/auth/send_opt_model.dart';
import '../models/auth/update_password_dto.dart';
import '../models/auth/update_user_dto.dart';
import '../models/remote/files/file_data_model.dart';
import '../providers/auth_provider.dart';
import '../models/auth/demande_pro_particulier_body.dart';
import '../models/auth/demande_pro_particulier_me_response.dart';
import '../models/remote/user/contact_change_models.dart';

class AuthRepository {
  final dioClient = getIt<Dio>();
  Future<FileDataModel> uplaodFile({required File file}) async {
    try {
      final response = await AuthProvider(dioClient).uploadImage(file);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error, s) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error $s');
      throw Exception('Failed to load users: $error');
    }
  }

  Future<AccountCreationResponse> registrationEnterprise(
      {required EnterpriseRegistrationBody body}) async {
    try {
      final response =
          await AuthProvider(dioClient).registrationEnterprise(body);
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

  Future<AccountCreationResponse> registrationCustomer(
      {required CustomerRegistrationBody body}) async {
    try {
      final response = await AuthProvider(dioClient).registrationCustomer(body);
      inspect(response);
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

  Future<AccountCreationResponse> login({required LoginBodyModel body}) async {
    try {
      final response = await AuthProvider(dioClient).login(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      inspect(error);
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  Future<HttpResponse> sendOtp({required SendOptModel body}) async {
    try {
      final response = await AuthProvider(dioClient).sendOtp(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      inspect(error);
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  Future<HttpResponse> sendWhatsappOtp({required SendOptModel body}) async {
    try {
      final response = await AuthProvider(dioClient).sendWhatsappOtp(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to send WhatsApp OTP: ${dioError.message}');
    } catch (error) {
      inspect(error);
      log('Error: $error');
      throw Exception('Failed to send WhatsApp OTP: $error');
    }
  }

  Future<HttpResponse> updatePassword({required UpdatePasswordDto body}) async {
    try {
      final response = await AuthProvider(dioClient).updatePassword(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      inspect(error);
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  Future<AccountCreationResponse> loginWithOtp(
      {required LoginOtpBody body}) async {
    try {
      final response = await AuthProvider(dioClient).loginOtp(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      inspect(error);
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  Future<UpdateUserResponseModel> updateUser(
      {required String userId, required UpdateUserDto body}) async {
    try {
      final response = await AuthProvider(dioClient).updateUser(userId, body);
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

  Future<ConfigModel> getConfig() async {
    try {
      final response = await AuthProvider(dioClient).getCongig();
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

  // Étape 1: Envoyer l'OTP par email
  Future<HttpResponse> sendEmailOtp({required SendEmailOtpBody body}) async {
    try {
      final response = await AuthProvider(dioClient).sendEmailOtp(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to send email OTP: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to send email OTP: $error');
    }
  }

  Future<HttpResponse> sendRegistrationOTP({required SendEmailOtpBody body}) async {
    try {
      final response = await AuthProvider(dioClient).sendRegistrationOTP(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to send registration OTP: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to send registration OTP: $error');
    }
  }

  // Étape 2: Réinitialiser le mot de passe
  Future<HttpResponse> resetPassword({required ResetPasswordBody body}) async {
    try {
      final response = await AuthProvider(dioClient).resetPassword(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to reset password: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to reset password: $error');
    }
  }

  Future<VerifyEmailResponse?> verifyOtp({required VerifyEmailOtp body}) async {
    try {
      final response = await AuthProvider(dioClient).verifyOtp(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to send email OTP: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to send email OTP: $error');
    }
  }

  Future<HttpResponse> deleteAccount({required String userId}) async {
    try {
      final response = await AuthProvider(dioClient).deleteAccount(userId);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to delete account: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to delete account: $error');
    }
  }

  Future<AccountCreationResponse> socialLogin(
      {required SocialLoginBody body}) async {
    try {
      final response = await AuthProvider(dioClient).socialLogin(body);
      inspect(response);
      return response;
    } on DioException catch (_) {
      rethrow;
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to social login: $error');
    }
  }

  Future<HttpResponse> createDemandeProParticulier(
      {required DemandeProParticulierBody body}) async {
    try {
      final response =
          await AuthProvider(dioClient).createDemandeProParticulier(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      final data = dioError.response?.data;
      if (data is Map && data['message'] != null) {
        final message = data['message'].toString();
        throw Exception(message);
      }
      throw Exception('Failed to create demande pro: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to create demande pro: $error');
    }
  }

  Future<DemandeProParticulierMeResponse> getDemandeProParticulierMe() async {
    try {
      final response =
          await AuthProvider(dioClient).getDemandeProParticulierMe();
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      final data = dioError.response?.data;
      if (data is Map && data['message'] != null) {
        throw Exception(data['message'].toString());
      }
      throw Exception('Failed to get demande pro: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to get demande pro: $error');
    }
  }

  Future<ContactChangeResponse> requestContactChange(
      RequestContactChangeBody body) async {
    try {
      return await AuthProvider(dioClient).requestContactChange(body);
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      final data = dioError.response?.data;
      if (data is Map && data['message'] != null) {
        throw RequestResponseExeption(data['message'].toString());
      }
      throw RequestResponseExeption(dioError.message ?? 'Erreur réseau');
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }

  Future<UpdateUserResponseModel> confirmContactChange(
      ConfirmContactChangeBody body) async {
    try {
      return await AuthProvider(dioClient).confirmContactChange(body);
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      final data = dioError.response?.data;
      if (data is Map && data['message'] != null) {
        throw RequestResponseExeption(data['message'].toString());
      }
      throw RequestResponseExeption(dioError.message ?? 'Erreur réseau');
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }
}
