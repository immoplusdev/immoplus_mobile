import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/data/models/auth/reset_password_body.dart';
import 'package:immoplus/app/data/models/auth/send_email_otp_body.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';
import 'package:immoplus/app/features/reset_password/cubit/reset_password_cubit_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordCubitState> {
  ResetPasswordCubit() : super(const ResetPasswordCubitState.initial());

  String? _currentEmail;
  String? _currentOtp;

  /// Étape 1: Envoie un OTP par email
  Future<void> sendEmailOtp({required String email}) async {
    emit(const ResetPasswordCubitState.sendingEmailOtp());

    try {
      final body = SendEmailOtpBody(email: email);
      await AuthRepository().sendEmailOtp(body: body);

      _currentEmail = email;

      emit(const ResetPasswordCubitState.emailOtpSent(
          message:
              "Un code de vérification a été envoyé à votre adresse email."));

      log('Email OTP sent successfully for: $email',
          name: 'RESET_PASSWORD_CUBIT');
    } catch (e) {
      log(e.toString(), name: "SEND_EMAIL_OTP_ERROR");

      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(ResetPasswordCubitState.error(errorMessage: errorMessage));
    }
  }

  /// Étape 2: Vérifie l'OTP reçu par email
  Future<void> verifyEmailOtp({required String otp}) async {
    if (_currentEmail == null) {
      emit(const ResetPasswordCubitState.error(
          errorMessage: "Veuillez d'abord demander un code de vérification."));
      return;
    }
    _currentOtp = otp;

    emit(const ResetPasswordCubitState.emailVerified());
  }

  // Future<void> verifyEmailOtp({required String otp}) async {
  //   if (_currentEmail == null) {
  //     emit(const ResetPasswordCubitState.error(
  //         errorMessage: "Veuillez d'abord demander un code de vérification."));
  //     return;
  //   }

  //   emit(const ResetPasswordCubitState.verifyingEmail());

  //   try {
  //     final body = VerifyEmailBody(email: _currentEmail!, otp: otp);
  //     await AuthRepository.verifyEmailOtp(body: body);

  //     _currentOtp = otp;

  //     emit(const ResetPasswordCubitState.emailVerified());

  //     log('Email verified successfully for: $_currentEmail',
  //         name: 'RESET_PASSWORD_CUBIT');
  //   } catch (e) {
  //     log(e.toString(), name: "VERIFY_EMAIL_ERROR");

  //     String errorMessage = e.toString().replaceFirst('Exception: ', '');
  //     emit(ResetPasswordCubitState.error(errorMessage: errorMessage));
  //   }
  // }

  /// Étape 3: Réinitialise le mot de passe
  Future<void> resetPassword({required String newPassword}) async {
    if (_currentEmail == null || _currentOtp == null) {
      emit(const ResetPasswordCubitState.error(
          errorMessage:
              "Processus de vérification incomplet. Veuillez recommencer."));
      return;
    }

    emit(const ResetPasswordCubitState.resettingPassword());

    try {
      final body = ResetPasswordBody(
        username: _currentEmail!, // Utilisation de l'email comme username
        otp: _currentOtp!,
        newPassword: newPassword,
      );
      await AuthRepository().resetPassword(body: body);

      emit(const ResetPasswordCubitState.passwordResetSuccess(
          message: "Votre mot de passe a été réinitialisé avec succès."));

      // Réinitialiser les variables après succès
      _currentEmail = null;
      _currentOtp = null;

      log('Password reset successfully', name: 'RESET_PASSWORD_CUBIT');
    } catch (e) {
      log(e.toString(), name: "RESET_PASSWORD_ERROR");

      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(ResetPasswordCubitState.error(errorMessage: errorMessage));
    }
  }

  /// Remet le cubit à l'état initial
  void resetState() {
    _currentEmail = null;
    _currentOtp = null;
    emit(const ResetPasswordCubitState.initial());
  }

  /// Getters pour l'UI
  String? get currentEmail => _currentEmail;
  bool get canVerifyOtp => _currentEmail != null;
  bool get canResetPassword => _currentEmail != null && _currentOtp != null;
}
