import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus/app/core/error/app_error_mapper.dart';
import 'package:immoplus/app/data/models/remote/booking_mode/booking_mode_model.dart';
import 'package:immoplus/app/data/providers/client_provider.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookingModeRepository {
  BookingModeRepository(this._dio);

  final Dio _dio;

  Future<BookingModeModel> getBookingMode() async {
    try {
      final json = await ClientProvider(_dio).getBookingMode();
      return BookingModeModel.fromJson(Map<String, dynamic>.from(json as Map));
    } on DioException catch (dioError) {
      log('DioError (booking-mode): ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error (booking-mode): $error');
      throw AppErrorMapper.from(error);
    }
  }
}
