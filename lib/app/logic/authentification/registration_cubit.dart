import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/auth/account_creation_response.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';
import 'package:immoplus/app/features/otp_login/otp_login_page.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit_state.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/auth/customer_registration_body.dart';

@injectable
class RgistrationCubitCubit extends Cubit<RegistrationCubitState> {
  RgistrationCubitCubit(this.sessionManager, this.dio)
      : super(const RegistrationCubitState.initial());
  SessionManager sessionManager;
  Dio dio;
  createCustomerAccount({
    required CustomerRegistrationBody customerRegistrationBody,
    // required FileUploaderController fileUploaderControllerPhotoIdentite,
    // required FileUploaderController
    //     fileUploaderControllerPieceIdentite
  }) async {
    emit(const RegistrationCubitState.loading());
    try {
      //FileDataModel photoIdentite =
      //     await fileUploaderControllerPhotoIdentite.upladFile();
      // log(photoIdentite.toString(), name: 'FIle Uploaded');
      // FileDataModel pieceIdentite =
      //     await fileUploaderControllerPieceIdentite.upladFile();
      // log(pieceIdentite.toString(), name: 'FIle Uploaded');

      // final body = particulierRegistrationBody.copyWith(
      //   pieceIdentiteId: pieceIdentite.data!.id,
      //   photoIdentiteId: photoIdentite.data!.id,
      // );
      AccountCreationResponse response = await AuthRepository()
          .registrationCustomer(body: customerRegistrationBody);

      // await SessionManager().saveUser(
      //   UserModelSchema()
      //     ..id = 1
      //     ..userId = response.data.user.id
      //     ..firstName = response.data.user.firstName
      //     ..lastName = response.data.user.lastName
      //     ..phoneNumber = response.data.user.phoneNumber
      //     ..email = response.data.user.email
      //     ..accessToken = response.data.accessToken
      //     ..refreshToken = response.data.refreshToken
      //     ..roleName = response.data.user.role.name
      //     ..activite = response.data.user.additionalData.activite
      //     ..nomEntreprise = response.data.user.additionalData.nomEntreprise
      //     ..photoIdentite = response.data.user.additionalData.photoIdentiteId
      //     ..pieceIdentite = response.data.user.additionalData.pieceIdentiteId
      //     ..emailEntreprise = response.data.user.additionalData.emailEntreprise,
      // );
      emit(const RegistrationCubitState.initial());
      NavigationService.navigatorKey.currentContext!.goNamed(OTPLoginPage.name);
    } catch (e) {
      log(e.toString(), name: "ERROR BLOC");

      emit(const RegistrationCubitState.initial());
    }
  }
}
