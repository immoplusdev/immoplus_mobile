import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/notification_service.dart';
import 'package:immoplus/app/data/models/auth/account_creation_response.dart';
import 'package:immoplus/app/data/models/local/user_model_schema.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/otp_login/otp_login_page.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit_state.dart';
import 'package:immoplus/app/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/auth/customer_registration_body.dart';

@injectable
class RgistrationCubitCubit extends Cubit<RegistrationCubitState> {
  RgistrationCubitCubit(this.sessionManager, this.dio, this.notificationService)
      : super(const RegistrationCubitState.initial());
  SessionManager sessionManager;
  Dio dio;

  NotificationService notificationService;
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
      emit(RegistrationCubitState.success(accountCreationResponse: response));
      NavigationService.navigatorKey.currentContext!.goNamed(HomePage.name);
      if (NavigationService.navigatorKey.currentContext!.canPop()) {
        NavigationService.navigatorKey.currentContext!.pop();
      }
    } catch (e) {
      log(e.toString(), name: "ERROR BLOC");

      emit(const RegistrationCubitState.initial());
    }
  }
}
