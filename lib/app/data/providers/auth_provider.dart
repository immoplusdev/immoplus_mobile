import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:immoplus/app/data/models/auth/reset_password_body.dart';
import 'package:immoplus/app/data/models/auth/send_email_otp_body.dart';
import 'package:immoplus/app/data/models/auth/social_login_body.dart';
import 'package:immoplus/app/data/models/auth/verify_email_otp.dart';
import 'package:immoplus/app/data/models/auth/verify_email_response.dart';
import 'package:immoplus/app/data/models/remote/configs/config_model.dart';

import 'package:retrofit/retrofit.dart';

import '../models/auth/account_creation_response.dart';
import '../models/auth/customer_registration_body.dart';
import '../models/auth/enterprise_registration_body.dart';
import '../models/auth/login_body_model.dart';
import '../models/auth/login_otp_body.dart';
import '../models/auth/particulier_registration_body.dart';
import '../models/auth/send_opt_model.dart';
import '../models/auth/update_password_dto.dart';
import '../models/auth/update_user_dto.dart';
import '../models/auth/update_user_response_model.dart';
import '../models/remote/files/file_data_model.dart';
import '../models/auth/demande_pro_particulier_body.dart';
import '../models/auth/demande_pro_particulier_me_response.dart';
import '../models/remote/user/contact_change_models.dart';

part 'auth_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class AuthProvider {
  factory AuthProvider(Dio dio, {String baseUrl}) = _AuthProvider;

  @POST("/files/public")
  @MultiPart()
  Future<FileDataModel> uploadImage(
    @Part(name: "file") File file,
  );
  @POST('/auth/send-sms-otp')
  Future<HttpResponse> sendOtp(@Body() SendOptModel sendOptModel);

  @POST('/auth/send-whatsapp-otp')
  Future<HttpResponse> sendWhatsappOtp(@Body() SendOptModel sendOptModel);

  @POST('/auth/login-with-phone-number-otp')
  Future<AccountCreationResponse> loginOtp(@Body() LoginOtpBody loginOtpBody);

  @POST('/auth/login')
  Future<AccountCreationResponse> login(@Body() LoginBodyModel loginBodyModel);
  @POST('/auth/register-customer')
  Future<AccountCreationResponse> registrationCustomer(
      @Body() CustomerRegistrationBody customRegistrationBody);

  @POST('/auth/register-pro-entreprise')
  Future<AccountCreationResponse> registrationEnterprise(
      @Body() EnterpriseRegistrationBody enterpriseRegistrationBody);

  @POST('/auth/register-pro-particulier')
  Future<AccountCreationResponse> registrationParticulier(
      @Body() ParticulierRegistrationBody particulierRegistrationBody);

  @POST('/auth/update-password')
  Future<HttpResponse> updatePassword(@Body() UpdatePasswordDto updateUserDto);

  @POST('/demandes-pro-particulier')
  Future<HttpResponse> createDemandeProParticulier(
      @Body() DemandeProParticulierBody body);

  @PATCH('/users/{id}')
  Future<UpdateUserResponseModel> updateUser(
      @Path() String id, @Body() UpdateUserDto updateUserDto);

  @GET('/users/{id}')
  Future<UpdateUserResponseModel> getUserById(@Path() String id);

  @GET('/configs')
  Future<ConfigModel> getCongig();

  @POST('/auth/send-email-otp')
  Future<HttpResponse> sendEmailOtp(@Body() SendEmailOtpBody sendEmailOtpBody);

  @POST('/auth/reset-password')
  Future<HttpResponse> resetPassword(
      @Body() ResetPasswordBody resetPasswordBody);

  @POST('/users/send-otp')
  Future<HttpResponse> sendRegistrationOTP(@Body() SendEmailOtpBody sendEmailOtpBody);

  @POST('/users/verify-otp')
  Future<VerifyEmailResponse> verifyOtp(
      @Body() VerifyEmailOtp sendEmailOtpBody);

  @DELETE('/users/{id}')
  Future<HttpResponse> deleteAccount(@Path() String id);

  @POST('/auth/social-login')
  Future<AccountCreationResponse> socialLogin(
      @Body() SocialLoginBody socialLoginBody);

  @GET('/demandes-pro-particulier/me')
  Future<DemandeProParticulierMeResponse> getDemandeProParticulierMe();

  @POST('/users/request-contact-change')
  Future<ContactChangeResponse> requestContactChange(
    @Body() RequestContactChangeBody body,
  );

  @POST('/users/confirm-contact-change')
  Future<UpdateUserResponseModel> confirmContactChange(
    @Body() ConfirmContactChangeBody body,
  );
}
