import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/demande_visit_request_body.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_response.dart';
import 'package:immoplus/app/data/providers/bien_immobilier_provider.dart';
import 'package:immoplus/app/data/providers/reservation_provider.dart';
import 'package:injectable/injectable.dart';

import '../models/remote/bienimmobilier/bien_immobilier_collection.dart';
import '../models/remote/bienimmobilier/bien_immobilier_single.dart';
import '../models/remote/bienimmobilier/date_demande_visite.dart';
import '../models/remote/bienimmobilier/demande_visit_response.dart';
import '../models/remote/bienimmobilier/demande_visite_collection.dart';
import '../models/remote/bienimmobilier/demande_visite_model.dart';
import '../models/remote/bienimmobilier/visit_programmer_body.dart';

@injectable
class BienImmobilierRepository {
  final Dio dioClient;
  BienImmobilierRepository(this.dioClient);
  Future<BienImmobilierCollection> getBiensImmobiliers({
    required int page,
    String? orderBy,
    String? orderDir,
    Map<String, dynamic>? where,
    String? search,
    double? lat,
    double? long,
    int? perPage,
    double? radius,
    String? startDate,
    String? endDate,
  }) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response = await BienImmobilierProvider(dioClient).getImmobiliers(
        page: page,
        orderBy: orderBy,
        orderDir: orderDir,
        where: where,
        search: search,
        lat: lat,
        long: long,
        perPage: perPage,
        radius: radius,
        startDate: startDate,
        endDate: endDate,
      );
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log(dioError.requestOptions.uri.toString(), name: "URI");
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      inspect(error);
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  Future<BienImmobilierCollection> getBiensImmobiliersProprietaireId({
    required String proprietaireId,
    required int page,
    String? orderBy,
    String? orderDir,
    Map<String, dynamic>? where,
    String? search,
    double? lat,
    double? long,
    int? perPage,
    double? radius,
    String? startDate,
    String? endDate,
  }) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response =
          await BienImmobilierProvider(dioClient).getImmobiliersProprietaireId(
        proprietaireId: proprietaireId,
        page: page,
        orderBy: orderBy,
        orderDir: orderDir,
        where: where,
        search: search,
        lat: lat,
        long: long,
        perPage: perPage,
        radius: radius,
        startDate: startDate,
        endDate: endDate,
      );
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log(dioError.requestOptions.uri.toString(), name: "URI");
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      inspect(error);
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
    double? radius,
    int? perPage,
    String? orderBy,
    String? orderDir,
    List<Map<String, dynamic>>? where,
    String? search,
  }) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response =
          await BienImmobilierProvider(dioClient).getBienImmobilierGeolocalized(
        lat: lat,
        long: long,
        search: search,
        where: where,
        page: page,
        orderBy: orderBy,
        orderDir: orderDir,
        radius: radius,
        perPage: perPage,
      );

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

  // Future<DemandeVisitResponse> annulerVisiteClient({
  //   required String visiteId,
  //   required String notes,
  // }) async {
  //   try {
  //     final response =
  //         await BienImmobilierProvider(dioClient).annulerVisiteClient(
  //       visiteId,
  //       {'notes': notes},
  //     );
  //     return response;
  //   } on DioException catch (e) {
  //     throw Exception('Erreur annulation visite: ${e.message}');
  //   }
  // }
}
