import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:immoplus/app/data/models/remote/user_preference/user_preference.dart';
import 'package:immoplus/app/data/models/remote/user_preference/user_preference_options.dart';
import 'package:immoplus/app/data/providers/user_preference_provider.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserPreferenceRepository {
  final Dio _dio;

  UserPreferenceRepository(this._dio);

  Future<UserPreferenceOptionsResponse> getOptions() async {
    try {
      return await UserPreferenceProvider(_dio).getOptions();
    } on DioException catch (e) {
      log('DioError (getOptions): ${e.message}');
      throw Exception(
          'Erreur lors de la récupération des options : ${e.message}');
    } catch (e) {
      log('Error (getOptions): $e');
      throw Exception(
          'Une erreur est survenue lors de la récupération des options.');
    }
  }

  Future<UserPreferenceResponse> getMyPreferences() async {
    try {
      return await UserPreferenceProvider(_dio).getMyPreferences();
    } on DioException catch (e) {
      log('DioError (getMyPreferences): ${e.message}');
      throw Exception(
          'Erreur lors de la récupération de vos préférences : ${e.message}');
    } catch (e, s) {
      log('Error (getMyPreferences): $e $s');
      throw Exception(
          'Une erreur est survenue lors de la récupération de vos préférences.');
    }
  }

  Future<UserPreferenceResponse> updateMyPreferences(
      UserPreferenceRequest request) async {
    try {
      return await UserPreferenceProvider(_dio).updateMyPreferences(request);
    } on DioException catch (e) {
      log('DioError (updateMyPreferences): ${e.message}');
      throw Exception(
          'Erreur lors de la mise à jour de vos préférences : ${e.message}');
    } catch (e) {
      log('Error (updateMyPreferences): $e');
      throw Exception(
          'Une erreur est survenue lors de la mise à jour de vos préférences.');
    }
  }
}
