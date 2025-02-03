import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/configs/ville_collection.dart';
import 'package:immoplus/app/data/providers/configs_provider.dart';

import '../models/remote/configs/commune_collection.dart';

class ConfigRepository {
  final dioClient = getIt<Dio>();

  Future<CommuneCollection> getCommunes(
      {required int page, required int perPage}) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response =
          await ConfigsProvider(dioClient).getCommunes(page, perPage);

      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  Future<VilleCollection> getVilles(
      {required int page, required int perPage}) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response =
          await ConfigsProvider(dioClient).getVilles(page, perPage);

      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }
}
