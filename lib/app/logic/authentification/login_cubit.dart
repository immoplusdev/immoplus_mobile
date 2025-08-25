import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/notification_service.dart';
import 'package:immoplus/app/data/models/auth/account_creation_response.dart';
import 'package:immoplus/app/data/models/auth/login_body_model.dart';
import 'package:immoplus/app/data/models/auth/login_otp_body.dart';
import 'package:immoplus/app/data/models/auth/send_opt_model.dart';
import 'package:immoplus/app/data/models/auth/update_password_dto.dart';
import 'package:immoplus/app/data/models/auth/update_user_dto.dart';
import 'package:immoplus/app/data/models/auth/update_user_response_model.dart';
import 'package:immoplus/app/data/models/local/user_model_schema.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/logic/authentification/login_cubit_state.dart';
import 'package:immoplus/app/screens/splash_screen.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:immoplus/app/utils/status_code_handler.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';
import 'package:injectable/injectable.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:retrofit/retrofit.dart';
import 'package:toastification/toastification.dart';

@injectable
class LoginCubit extends Cubit<LoginCubitState> {
  LoginCubit(this.sessionManager, this.dio, this.notificationService)
      : super(const LoginCubitState.initial());
  SessionManager sessionManager;
  NotificationService notificationService;
  Dio dio;
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
      toastification.show(
        type: ToastificationType.success,
        context: NavigationService.navigatorKey
            .currentContext, // optional if you use ToastificationWrapper

        title: Text(
            "Vos informations personnelles ont été mises à jour avec succès"),
        autoCloseDuration: const Duration(seconds: 5),

        showProgressBar: false,
        alignment: Alignment.bottomCenter,
        style: ToastificationStyle.flatColored,
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
        AppDialog.info(
            content: 'Mot de passe modifié avec succès',
            icon: const Icon(
              FontAwesomeIcons.circleCheck,
              color: Colors.green,
            ));
        emit(const LoginCubitState.success());
        NavigationService.navigatorKey.currentContext!
            .goNamed(SplashScreen.name);
      } else {
        AppDialog.info(
            content: 'Erreur lors de la modification du mot de passe',
            icon: const Icon(
              FontAwesomeIcons.circleXmark,
              color: Colors.red,
            ));
        emit(const LoginCubitState.initial());
      }

      emit(const LoginCubitState.success());
      NavigationService.navigatorKey.currentContext!.goNamed(SplashScreen.name);
    } catch (e) {
      AppDialog.info(
          content: 'Erreur lors de la modification du mot de passe',
          icon: const Icon(
            FontAwesomeIcons.circleXmark,
            color: Colors.red,
          ));
      emit(const LoginCubitState.initial());
    }
  }
}
