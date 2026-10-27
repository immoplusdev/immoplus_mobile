import 'package:immoplus/app/core/error/app_error_mapper.dart';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/remote/hotel/hotel_model.dart';
import '../models/remote/hotel/hotel_detail_model.dart';
import '../models/remote/hotel/hotel_response.dart';
import '../models/remote/hotel/hotels_collection.dart';
import '../models/remote/hotel/hotel_estimation_request.dart';
import '../models/remote/hotel/hotel_estimation_response.dart';
import '../models/remote/hotel/hotel_villes_response.dart';
import '../models/remote/hotel/hotel_room_detail_model.dart';
import '../models/remote/hotel/hotel_reservation_request.dart';
import '../models/remote/hotel/hotel_reservation_response.dart';
import '../models/remote/hotel/hotel_payment_request.dart';
import '../models/remote/hotel/hotel_payment_response.dart';
import '../models/remote/hotel/hotel_payment_methods_response.dart';
import '../models/remote/hotel/hotel_module_status_response.dart';
import '../providers/hotel_provider.dart';

@injectable
class HotelRepository {
  final Dio dioClient;
  HotelRepository(this.dioClient);

  Future<HotelRoomDetailModel> getRoomDetail(
      String hotelId, String roomTypeId) async {
    try {
      final response =
          await HotelProvider(dioClient).getRoomDetail(hotelId, roomTypeId);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }

  /// Statut d'activation globale du module Hôtel (flag plateforme).
  Future<HotelModuleStatusResponse> getModuleStatus() async {
    try {
      final response = await dioClient.get('/pms/hotels/module-status');
      return HotelModuleStatusResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception(
          'Failed to load hotel module status: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }

  Future<HotelDetailModel> getHotel(String id) async {
    try {
      final response = await HotelProvider(dioClient).getHotel(id);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }

  Future<HotelsCollection> getHotels({
    double? lat,
    double? long,
    double? radius,
    String? villeId,
    bool? isSponsored,
    String? checkInDate,
    String? checkOutDate,
    int? adults,
    int? children,
    int? lits,
  }) async {
    try {
      final response = await HotelProvider(dioClient).getHotels(
        lat: lat,
        long: long,
        radius: radius,
        villeId: villeId,
        isSponsored: isSponsored,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        adults: adults,
        children: children,
        lits: lits,
      );
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }

  Future<List<HotelVillesResponse>> getVilles() async {
    try {
      final response = await HotelProvider(dioClient).getVilles();
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }

  Future<HotelEstimationResponse> getEstimation({
    required String hotelId,
    required HotelEstimationRequest request,
  }) async {
    try {
      final response =
          await HotelProvider(dioClient).getEstimation(hotelId, request);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception(
          'Failed to get hotel reservation estimation: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }

  Future<HotelReservationResponse> createReservation({
    required String hotelId,
    required HotelReservationRequest request,
  }) async {
    try {
      final response =
          await HotelProvider(dioClient).createReservation(hotelId, request);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }

  Future<HotelPaymentMethodsResponse> getPaymentMethods(String hotelId) async {
    try {
      final response =
          await HotelProvider(dioClient).getPaymentMethods(hotelId);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }

  Future<HotelPaymentResponse> initPayment({
    required String hotelId,
    required String reservationId,
    required HotelPaymentRequest request,
  }) async {
    try {
      final response = await HotelProvider(dioClient)
          .initPayment(hotelId, reservationId, request);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }
}
