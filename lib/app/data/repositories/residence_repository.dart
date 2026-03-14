import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/enums/order_dir.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_response.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservations_collection.dart';
import 'package:immoplus/app/data/models/remote/reservations/status_reservation.dart';

import 'package:immoplus/app/data/providers/reservation_provider.dart';
import 'package:immoplus/app/data/providers/residence_provider.dart';
import 'package:injectable/injectable.dart';

import '../models/remote/reservations/reservation_request_body.dart';
import '../models/remote/residence/residence_response.dart';
import '../models/remote/residence/residences_collection.dart';

@injectable
class ResidenceRepository {
  Dio dioClient;
  ResidenceRepository(this.dioClient);

  Future<ReservationsCollection> getReservations({
    required int page,
    required int perPage,
    String? orderBy,
    String? orderDir,
    String? search,
    List<String>? where,
  }) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response = await ReservationProvider(dioClient)
          .getBookings(search, page, perPage, orderBy, orderDir, where);
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

  /// Récupère la dernière réservation en attente de réponse du propriétaire
  Future<ReservationModel?> getLatestPendingProprietaireReponse() async {
    try {
      final where = [
        '{"_field": "statusReservation", "_op": "eq", "_val": "${StatusReservation.enAttenteReponseProprietaire.backendValue}"}',
        '{ "_field": "statusFacture", "_op": "eq", "_val": "non_paye"}'
      ];
      final result = await getReservations(
        page: 1,
        perPage: 1,
        where: where,
        orderBy: OrderByField.createdAt.value,
        orderDir: OrderDir.desc.value,
      );
      if (result.data.isNotEmpty) return result.data.first;
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<ReservationModel> annulerReservationClient({
  required String reservationId,
  required String notes,
}) async {
  try {
    final response = await ReservationProvider(dioClient)
        .annulerReservationClient(
          reservationId,
          {'notes': notes},
        );
    return response.data;
  } on DioException catch (e) {
    throw Exception('Erreur annulation: ${e.message}');
  }
}



  /// Récupère les réservations en attente de paiement client
  Future<ReservationsCollection> getReservationsEnAttentePaiement({
    int page = 1,
    int perPage = 10,
  }) {
    final where = [
      '{"_field": "statusReservation", "_op": "eq", "_val": "${StatusReservation.enAttentePaiementClient.backendValue}"}',
      '{ "_field": "statusFacture", "_op": "eq", "_val": "non_paye"}'
    ];
    return getReservations(
      page: page,
      perPage: perPage,
      where: where,
      orderBy: OrderByField.createdAt.value,
      orderDir: OrderDir.desc.value,
    );
  }



  Future<ReservationsCollection> getReservationsOwner({
    required String id,
    required int page,
    required int perPage,
    String? orderBy,
    String? orderDir,
    String? search,
  }) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response = await ReservationProvider(dioClient)
          .getBookingsOwner(search, id, page, perPage, orderBy, orderDir);
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

  Future<ReservationResponse> annulerReservations({required String id}) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response = await ReservationProvider(dioClient).annulerBookings(id);
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

  Future<ReservationResponse> createBooking(
      {required ReservationRequestBody model}) async {
    try {
      final response =
          await ReservationProvider(dioClient).createBookings(model);
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

  Future<ResidencesCollection> getResidences({
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
      final response = await ResidenceProvider(dioClient).getResidences(
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

  Future<ResidencesCollection> getResidencesProprietaire({
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
          await ResidenceProvider(dioClient).getResidencesProprietaire(
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

  Future<ResidencesCollection> getResidencesLocalized({
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
          await ResidenceProvider(dioClient).getResidencesGeolocalized(
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

  Future<ResidenceResponse> getResidence(String id) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response = await ResidenceProvider(dioClient).getResidence(id);

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
