import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/notification_service.dart';
import 'package:immoplus/app/data/enums/account_source.dart';
import 'package:immoplus/app/data/enums/api_error_code.dart';
import 'package:immoplus/app/data/error/api_error_response.dart';
import 'package:immoplus/app/data/models/auth/account_creation_response.dart';
import 'package:immoplus/app/data/models/auth/login_body_model.dart';
import 'package:immoplus/app/data/models/auth/login_otp_body.dart';
import 'package:immoplus/app/data/models/auth/send_opt_model.dart';
import 'package:immoplus/app/data/models/auth/social_body_enum.dart';
import 'package:immoplus/app/data/models/auth/social_login_body.dart';
import 'package:immoplus/app/data/models/auth/update_password_dto.dart';
import 'package:immoplus/app/data/models/auth/update_user_dto.dart';
import 'package:immoplus/app/data/models/auth/update_user_response_model.dart';
import 'package:immoplus/app/data/models/local/user_model_schema.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/registration/customer_registration.dart';
import 'package:immoplus/app/logic/authentification/login_cubit_state.dart';
import 'package:immoplus/app/screens/splash_screen.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:immoplus/app/utils/status_code_handler.dart';
import 'package:immoplus/app/utils/toast_utils.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';
import 'package:injectable/injectable.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:retrofit/retrofit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SocialLoginUser {
  final String? firstName;
  final String? phoneNumber;
  final String email;
  final String? lastName;
  final String? provider;

  SocialLoginUser(
      {this.firstName,
      required this.email,
      this.lastName,
      this.phoneNumber,
      required this.provider});
}

@injectable
class LoginCubit extends Cubit<LoginCubitState> {
  LoginCubit(this.sessionManager, this.dio, this.notificationService)
      : super(const LoginCubitState.initial());
  SessionManager sessionManager;
  NotificationService notificationService;
  Dio dio;
  SocialLoginUser? socialLoginUser;
  onSendData({required LoginBodyModel body}) async {
    emit(const LOGIN_LOADING());
    try {
      AccountCreationResponse response =
          await AuthRepository().login(body: body);

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
      dio.options.headers['Authorization'] =
          'Bearer ${sessionManager.currentUser!.accessToken}';
      emit(const LoginCubitState.success());
      NavigationService.navigatorKey.currentContext!.goNamed(HomePage.name);
      if (NavigationService.navigatorKey.currentContext!.canPop()) {
        NavigationService.navigatorKey.currentContext!.pop();
      }
    } catch (e) {
      emit(const LoginCubitState.initial());
    }
  }

  sendOtp(
      {required SendOptModel body,
      required PageController pageController}) async {
    emit(const LOGIN_LOADING());
    final response = await AuthRepository().sendOtp(body: body);
    if (StatusCodeHandler.isSuccess(response.response.statusCode)) {
      emit(const LoginCubitState.initial());
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      CustomPopup.showErrorToast(
          text: 'Envoie du code échoué veuillez ressayer');
      emit(const LoginCubitState.initial());
    }
  }

  onSendOtpData({required LoginOtpBody body}) async {
    emit(const LOGIN_LOADING());
    try {
      AccountCreationResponse response =
          await AuthRepository().loginWithOtp(body: body);

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
      // OneSignal.login(response.data.user.id ?? 'user');
      await sessionManager.getCurrentUser();
      notificationService.suscribeCurrentUser();
      dio.options.headers['Authorization'] =
          'Bearer ${sessionManager.currentUser!.accessToken}';
      emit(const LoginCubitState.success());
      NavigationService.navigatorKey.currentContext!.goNamed(SplashScreen.name);
    } catch (e) {
      emit(const LoginCubitState.initial());
    }
  }

  updateUserData({required UpdateUserDto body}) async {
    emit(const LOGIN_LOADING());
    try {
      UpdateUserResponseModel response = await AuthRepository()
          .updateUser(userId: sessionManager.currentUser!.userId!, body: body);
      //_checkRole(response.data.role.name);
      await sessionManager.saveUser(
        UserModelSchema()
          ..id = 1
          ..userId = response.data.id
          ..firstName = response.data.firstName
          ..role = response.data.role.name
          ..lastName = response.data.lastName
          ..avatar = response.data.avatar
          ..phoneNumber = response.data.phoneNumber
          ..email = response.data.email
          ..accessToken = sessionManager.currentUser!.accessToken
          ..refreshToken = sessionManager.currentUser!.refreshToken
          ..roleName = response.data.role.name
          ..activite = response.data.additionalData.activite
          ..nomEntreprise = response.data.additionalData.nomEntreprise
          ..photoIdentite = response.data.additionalData.photoIdentiteId
          ..pieceIdentite = response.data.additionalData.pieceIdentiteId
          ..emailEntreprise = response.data.additionalData.emailEntreprise,
      );
      // OneSignal.login(response.data.user.id ?? 'user');
      await sessionManager.getCurrentUser();

      emit(const LoginCubitState.success());
      ToastUtils.success(
        "Vos informations personnelles ont été mises à jour avec succès",
      );
    } catch (e) {
      emit(const LoginCubitState.initial());
    }
  }

  updatePassword({required UpdatePasswordDto body}) async {
    emit(const LOGIN_LOADING());
    try {
      HttpResponse response = await AuthRepository().updatePassword(body: body);

      // OneSignal.login(response.data.user.id ?? 'user');
      await sessionManager.getCurrentUser();
      if (response.response.statusCode! >= 200 &&
          response.response.statusCode! < 300) {
        ToastUtils.success(
          'Votre mot de passe a bien été modifié',
        );
        emit(const LoginCubitState.success());
        NavigationService.navigatorKey.currentContext?.pop(SplashScreen.name);
      } else {
        emit(const LoginCubitState.initial());
      }
    } catch (e) {
      emit(const LoginCubitState.initial());
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const LOGIN_LOADING());
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

      await _googleSignIn.initialize();
      _googleSignIn.signOut();

      final List<String> scopes = [
        'https://www.googleapis.com/auth/userinfo.email',
      ];

      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate(
        scopeHint: scopes,
      );

      if (googleUser == null) {
        // L'utilisateur a annulé la connexion
        emit(const LoginCubitState.initial());
        return;
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      socialLoginUser = SocialLoginUser(
        firstName: googleUser.displayName?.split(' ').first ?? '',
        lastName: googleUser.displayName?.split(' ').last ?? '',
        email: googleUser.email,
        provider: SocialProviderEnum.google.value,
      );
      // Appel à l'API avec le token Google
      final body = SocialLoginBody(
        provider: SocialProviderEnum.google.value,
        token: googleAuth.idToken ?? '',
        email: googleUser.email,
        source: AccountSource.customerApp.value,
      );

      await _performSocialLogin(body);
    } catch (e, s) {
      log(" Error Google Sign-In: $e ", stackTrace: s);
      CustomPopup.showErrorToast(
          text: 'Erreur lors de la connexion avec Google');
      emit(const LoginCubitState.initial());
    }
  }

  Future<void> signInWithFacebook() async {
    emit(const LOGIN_LOADING());
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        // Récupérer les infos utilisateur
        final userData = await FacebookAuth.instance.getUserData(
          fields: "email,name",
        );

        final body = SocialLoginBody(
          provider: SocialProviderEnum.facebook.value,
          token: accessToken.tokenString,
          email: userData['email'] ?? '',
          source: AccountSource.customerApp.value,
        );

        await _performSocialLogin(body);
      } else if (result.status == LoginStatus.cancelled) {
        emit(const LoginCubitState.initial());
      } else {
        CustomPopup.showErrorToast(
            text: 'Erreur lors de la connexion avec Facebook');
        emit(const LoginCubitState.initial());
      }
    } catch (e) {
      CustomPopup.showErrorToast(
          text: 'Erreur lors de la connexion avec Facebook');
      emit(const LoginCubitState.initial());
    }
  }

// Méthode commune pour les connexions sociales
  Future<void> _performSocialLogin(SocialLoginBody body) async {
    try {
      AccountCreationResponse response =
          await AuthRepository().socialLogin(body: body);

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

      await sessionManager.getCurrentUser();
      notificationService.suscribeCurrentUser();
      dio.options.headers['Authorization'] =
          'Bearer ${sessionManager.currentUser!.accessToken}';
      emit(const LoginCubitState.success());
      NavigationService.navigatorKey.currentContext!.goNamed(HomePage.name);
      if (NavigationService.navigatorKey.currentContext!.canPop()) {
        NavigationService.navigatorKey.currentContext!.pop();
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;
      final errorResponse = ApiErrorResponse.fromJson(errorData);
      if (errorResponse.errorCode == ApiErrorCode.socialAccountNotFound) {
        emit(const LoginCubitState.initial());
        _redirectToSocialRegistration(body);
        return;
      }
      log('❌ Erreur social login: $e');
    } catch (e) {
      log('❌ Erreur inattendue: $e');
    } finally {
      emit(const LoginCubitState.initial());
    }
  }

  void _redirectToSocialRegistration(SocialLoginBody socialBody) {
    // Récupérer les infos depuis le token si besoin
    final context = NavigationService.navigatorKey.currentContext;

    if (context == null) return;
    context.pushNamed(CustomerRegistration.name,
        extra: DataRouterRegistration(
          email: socialBody.email,
          token: socialBody.token,
          firstName: socialLoginUser?.firstName,
          lastName: socialLoginUser?.lastName,
          provider: socialLoginUser?.provider,
        ));
  }
}
