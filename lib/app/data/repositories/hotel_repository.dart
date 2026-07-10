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
import '../providers/hotel_provider.dart';

@injectable
class HotelRepository {
  final Dio dioClient;
  HotelRepository(this.dioClient);

  Future<HotelRoomDetailModel> getRoomDetail(String hotelId, String roomTypeId) async {
    try {
      final response = await HotelProvider(dioClient).getRoomDetail(hotelId, roomTypeId);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load room detail: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to load room detail: $error');
    }
  }

  Future<HotelDetailModel> getHotel(String id) async {
    try {
      final response = await HotelProvider(dioClient).getHotel(id);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load hotel detail: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to load hotel detail: $error');
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
      throw Exception('Failed to load hotels list: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to load hotels list: $error');
    }
  }

  Future<List<HotelVillesResponse>> getVilles() async {
    try {
      final response = await HotelProvider(dioClient).getVilles();
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load hotel villes: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to load hotel villes: $error');
    }
  }

  Future<HotelEstimationResponse> getEstimation({
    required String hotelId,
    required HotelEstimationRequest request,
  }) async {
    try {
      final response = await HotelProvider(dioClient).getEstimation(hotelId, request);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to get hotel reservation estimation: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to get hotel reservation estimation: $error');
    }
  }
}
