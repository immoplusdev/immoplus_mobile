import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/remote/kyc/kyc_session_model.dart';
import '../models/remote/kyc/kyc_session_create_model.dart';
import '../providers/kyc_provider.dart';

@injectable
class KycRepository {
  final Dio dioClient;
  KycRepository(this.dioClient);

  Future<KycSessionModel?> getKycSessionMe() async {
    try {
      final response = await KycProvider(dioClient).getKycSessionMe();
      return response.data;
    } on DioException catch (e) {
      log('KycRepository: Error getting current KYC session: ${e.message}');
      rethrow;
    } catch (e) {
      log('KycRepository: Error getting current KYC session: $e');
      rethrow;
    }
  }

  Future<KycSessionCreateModel> createKycSession() async {
    try {
      final response = await KycProvider(dioClient).createKycSession();
      return response.data;
    } on DioException catch (e) {
      log('KycRepository: Error creating KYC session: ${e.message}');
      rethrow;
    } catch (e) {
      log('KycRepository: Error creating KYC session: $e');
      rethrow;
    }
  }

  Future<KycSessionModel?> verifyKyc({
    required String documentType,
    required File frontFile,
    File? backFile,
  }) async {
    try {
      final response = await KycProvider(dioClient).verifyKyc(
        documentType,
        frontFile,
        backFile: backFile,
      );
      return response.data;
    } on DioException catch (e) {
      log('KycRepository: Error verifying KYC: ${e.message}');
      rethrow;
    } catch (e) {
      log('KycRepository: Error verifying KYC: $e');
      rethrow;
    }
  }
}
