import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_response.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservations_collection.dart';

import 'package:immoplus/app/data/providers/reservation_provider.dart';
import 'package:immoplus/app/data/providers/residence_provider.dart';

import '../models/remote/reservations/reservation_request_body.dart';
import '../models/remote/residence/residence_response.dart';
import '../models/remote/residence/residences_collection.dart';

class ResidenceRepository {
  final dioClient = getIt<Dio>();

  Future<ReservationsCollection> getReservations({
    required int page,
    required int perPage,
    String? orderBy,
    String? orderDir,
    String? search,
  }) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response = await ReservationProvider(dioClient)
          .getBookings(search, page, perPage, orderBy, orderDir);
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
  }) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response = await ResidenceProvider(dioClient)
          .getResidences(search, where, page, orderBy, orderDir);

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
    String? orderBy,
    String? orderDir,
    List<Map<String, dynamic>>? where,
    String? search,
  }) async {
    //dioClient.options.queryParameters['meta'] = '*';
    try {
      final response = await ResidenceProvider(dioClient)
          .getResidencesGeolocalized(
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
