import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/auth_redirect_service.dart';
import 'package:immoplus/app/core/services/notification_service.dart';
import 'package:immoplus/app/data/models/auth/account_creation_response.dart';
import 'package:immoplus/app/data/models/auth/send_email_otp_body.dart';
import 'package:immoplus/app/data/models/auth/verify_email_otp.dart';
import 'package:immoplus/app/data/models/auth/verify_email_response.dart';
import 'package:immoplus/app/data/models/local/user_model_schema.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit_state.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/auth/customer_registration_body.dart';

@injectable
class RgistrationCubitCubit extends Cubit<RegistrationCubitState> {
  RgistrationCubitCubit(this.sessionManager, this.dio, this.notificationService,
      this.authRedirectService, this.analyticsService)
      : super(const RegistrationCubitState.initial());
  SessionManager sessionManager;
  Dio dio;

  NotificationService notificationService;
  final AuthRedirectService authRedirectService;
  final AnalyticsService analyticsService;

  void _navigateAfterRegistration() {
    final context = NavigationService.navigatorKey.currentContext!;
    final redirectData = authRedirectService.get();
    if (redirectData != null) {
      Navigator.of(context).popUntil(
        (route) => route.settings.name == redirectData.popUntilRouteName,
      );
      redirectData.callback();
      authRedirectService.clear();
    } else {
      context.goNamed(HomePage.name);
    }
  }

  createCustomerAccount({
    required CustomerRegistrationBody customerRegistrationBody,
    //required String? fileID,
  }) async {
    emit(const RegistrationCubitState.loading());
    try {
      AccountCreationResponse response = await AuthRepository()
          .registrationCustomer(body: customerRegistrationBody);

      await sessionManager.saveUser(
        UserModelSchema()
          ..id = 1
          ..userId = response.data.user.id
          ..firstName = response.data.user.firstName
          ..lastName = response.data.user.lastName
          ..phoneNumber = response.data.user.phoneNumber
          ..email = response.data.user.email
          ..avatar = response.data.user.avatar
          ..accessToken = response.data.accessToken
          ..refreshToken = response.data.refreshToken
          ..roleName = response.data.user.role.name
          ..activite = response.data.user.additionalData.activite
          ..nomEntreprise = response.data.user.additionalData.nomEntreprise
          ..photoIdentite = response.data.user.additionalData.photoIdentiteId
          ..pieceIdentite = response.data.user.additionalData.pieceIdentiteId
          ..emailEntreprise = response.data.user.additionalData.emailEntreprise,
      );
      //OneSignal.login(response.data.user.id ?? 'user');
      await sessionManager.getCurrentUser();
      notificationService.suscribeCurrentUser();
      final provider = customerRegistrationBody.provider ?? 'email';
      analyticsService.logSignUp(method: provider);
      analyticsService.setUserIdentity(
        user: sessionManager.currentUser!,
        city: response.data.user.city,
        accountType: sessionManager.currentUser!.roleName,
      );
      emit(RegistrationCubitState.success(accountCreationResponse: response));
      _navigateAfterRegistration();
    } catch (e) {
      log(e.toString(), name: "ERROR BLOC");

      emit(const RegistrationCubitState.initial());
    }
  }

  Future<bool> sendRegistrationOTP({required SendEmailOtpBody body}) async {
    emit(const RegistrationCubitState.loading());
    try {
      final response = await AuthRepository().sendRegistrationOTP(body: body);
      emit(RegistrationCubitState.initial());
      if ([200, 201].contains(response.response.statusCode)) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      emit(RegistrationCubitState.initial());
      return false;
    } catch (error) {
      log('Error: $error');
      emit(RegistrationCubitState.initial());
      return false;
    }
  }

  Future<bool> userSendOTP({
    String? email,
    String? phoneNumber,
    bool? is_whatssap,
  }) async {
    return sendRegistrationOTP(
      body: SendEmailOtpBody(
        email: email,
        phoneNumber: phoneNumber,
        is_whatssap: is_whatssap,
      ),
    );
  }

  Future<VerifyEmailResponse?> verifyOtp({
    String? email,
    String? phoneNumber,
    required String otp,
  }) async {
    emit(const RegistrationCubitState.loading());
    try {
      final body = VerifyEmailOtp(
        email: email,
        phoneNumber: phoneNumber,
        otp: otp,
      );
      final response = await AuthRepository().verifyOtp(body: body);
      emit(RegistrationCubitState.initial());
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      emit(RegistrationCubitState.initial());
      return null;
    } catch (error) {
      log('Error: $error');
      emit(RegistrationCubitState.initial());
      return null;
    }
  }
}
