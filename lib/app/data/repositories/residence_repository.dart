import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/exceptions/active_reservation_exception.dart';
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
      final result =
          await getReservationsEnAttenteProprietaire(page: 1, perPage: 1);
      if (result.data.isNotEmpty) return result.data.first;
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Récupère les réservations en attente de réponse du propriétaire
  Future<ReservationsCollection> getReservationsEnAttenteProprietaire({
    int page = 1,
    int perPage = 10,
  }) {
    final where = [
      '{"_field": "statusReservation", "_op": "eq", "_val": "${StatusReservation.enAttenteReponseProprietaire.backendValue}"}',
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

  Future<ReservationModel> annulerReservationClient({
    required String reservationId,
    required String notes,
  }) async {
    try {
      final response =
          await ReservationProvider(dioClient).annulerReservationClient(
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

  Future<Map<String, dynamic>> generateQrCheckin({required String id}) async {
    try {
      final response = await ReservationProvider(dioClient).generateQrCheckin(id);
      return response.data as Map<String, dynamic>;
    } on DioException catch (dioError) {
      log('DioError (generer-qr-checkin): ${dioError.message}');
      throw Exception('Failed to generate check-in QR: ${dioError.message}');
    } catch (error) {
      log('Error (generer-qr-checkin): $error');
      throw Exception('Failed to generate check-in QR: $error');
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
      // if (dioError.response?.statusCode == 400) {
      //   final data = dioError.response?.data;
      //   final reservationId = data?['data']?['reservationId'] as String?;
      //   final message = data?['message'] as String? ?? 'Une réservation est déjà en cours.';
      //   if (reservationId != null) {
      //     throw ActiveReservationException(
      //       message: message,
      //       reservationId: reservationId,
      //     );
      //   }
      // }
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
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

  Future<ResidencesCollection> searchResidencesPublic({
    String? zones,
    int? priceMin,
    int? priceMax,
    int? occupantsMin,
    String? startDate,
    String? endDate,
    int page = 1,
    int perPage = 50,
  }) async {
    try {
      final response =
          await ResidenceProvider(dioClient).searchResidencesPublic(
        zones: zones,
        priceMin: priceMin,
        priceMax: priceMax,
        occupantsMin: occupantsMin,
        startDate: startDate,
        endDate: endDate,
        page: page,
        perPage: perPage,
      );

      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to search residences: ${dioError.message}');
    } catch (error) {
      inspect(error);
      log('Error: $error');
      throw Exception('Failed to search residences: $error');
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
