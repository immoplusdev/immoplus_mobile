import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/demande_visit_request_body.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_response.dart';
import 'package:immoplus/app/data/providers/bien_immobilier_provider.dart';
import 'package:immoplus/app/data/providers/reservation_provider.dart';

import '../models/remote/bienimmobilier/bien_immobilier_collection.dart';
import '../models/remote/bienimmobilier/bien_immobilier_single.dart';
import '../models/remote/bienimmobilier/date_demande_visite.dart';
import '../models/remote/bienimmobilier/demande_visit_response.dart';
import '../models/remote/bienimmobilier/demande_visite_collection.dart';
import '../models/remote/bienimmobilier/demande_visite_model.dart';
import '../models/remote/bienimmobilier/visit_programmer_body.dart';

class BienImmobilierRepository {
  final dioClient = getIt<Dio>();

  Future<BienImmobilierCollection> getBiensImmobiliers(
      {required int page,
      required int perPage,
      required Map<String, dynamic>? where,
      String? orderBy,
      String? orderDir}) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response = await BienImmobilierProvider(dioClient)
          .getImmobiliers(page, perPage, where, orderBy, orderDir);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log(dioError.requestOptions.uri.toString(), name: "URI");
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  Future<DemandeVisiteCollection> getVisitesOwner({
    required String id,
    required int page,
    required int perPage,
    String? orderBy,
    String? orderDir,
    String? search,
  }) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response = await BienImmobilierProvider(dioClient)
          .getVisiteOwner(search, id, page, perPage, orderBy, orderDir);
      inspect(response);
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

  Future<DemandeVisiteCollection> getVisites({
    required int page,
    required int perPage,
    String? orderBy,
    String? orderDir,
    String? search,
  }) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response = await BienImmobilierProvider(dioClient)
          .getVisites(search, page, perPage, orderBy, orderDir);
      inspect(response);
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

  Future<DemandeVisitResponse> getVisit({required String id}) async {
    try {
      final response = await BienImmobilierProvider(dioClient).getVisite(id);
      inspect(response);
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

  Future<ReservationResponse> getReservation({required String id}) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response = await ReservationProvider(dioClient).getBooking(id);
      inspect(response);
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

  Future<DemandeVisitResponse> createVisit(
      {required DemandeVisitRequestBody model}) async {
    try {
      final response =
          await BienImmobilierProvider(dioClient).createVisite(model);
      inspect(response);
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

  Future<BienImmobilierSingle> getBiensImmobilier(String id) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response =
          await BienImmobilierProvider(dioClient).getImmobilier(id);

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

  Future<DemandeVisiteModel?> programmerVisit(String id, DateTime date) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response = await BienImmobilierProvider(dioClient).programmer(
          VisitProgrammerBody(
              datesDemandeVisite: [DateDemandeVisite(date: date)]));

      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      return null;
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      return null;
    }
  }

  Future<BienImmobilierCollection> getBiensLocalized({
    int? page,
    required double lat,
    required double long,
    String? orderBy,
    String? orderDir,
    String? where,
    String? search,
  }) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response = await BienImmobilierProvider(dioClient)
          .getBienImmobilierGeolocalized(
              lat, long, search, where, page, orderBy, orderDir);

      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      inspect(error);
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }
}
