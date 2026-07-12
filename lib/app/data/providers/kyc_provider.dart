import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../models/remote/kyc/kyc_session_response.dart';
import '../models/remote/kyc/kyc_session_create_response.dart';

part 'kyc_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class KycProvider {
  factory KycProvider(Dio dio, {String baseUrl}) = _KycProvider;

  @GET("/kyc/sessions/me")
  Future<KycSessionResponse> getKycSessionMe();

  @POST("/kyc/sessions")
  Future<KycSessionCreateResponse> createKycSession();

  @POST("/kyc/verify")
  @MultiPart()
  Future<KycSessionResponse> verifyKyc(
    @Part(name: "documentType") String documentType,
    @Part(name: "frontFile") File frontFile, {
    @Part(name: "backFile") File? backFile,
  });
}
