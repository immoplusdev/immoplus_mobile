import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus/app/features/booking/data/estimate_cost_model.dart';
import 'package:immoplus/app/features/booking/data/estimate_price_model.dart';
import 'package:immoplus/app/utils/request_path.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookingServices {
  final Dio dio;
  BookingServices(this.dio);

  Future<EstimatePriceModel> estimerPrix(
      {required String residenceId, required List<DateTime> dates}) async {
    try {
      final response = await dio.post(
        "${RequestPath.baseUrl}/reservations/action/estimer-prix",
        data: {
          "residence": residenceId,
          "datesReservation": dates
              .map((date) => {"date": date.toUtc().toIso8601String()})
              .toList(),
        },
      );
      return EstimatePriceModel.fromJson(response.data);
    } catch (e) {
      return EstimatePriceModel();
    }
  }

  Future<EstimateCostModel> estimateCost({
    required String residenceId,
    required DateTime dateDebut,
    required DateTime dateFin,
    // String paymentMethod = 'moov',
  }) async {
    try {
      final response = await dio.post(
        "${RequestPath.baseUrl}/reservations/estimate-cost",
        data: {
          "residenceId": residenceId,
          "dateDebut": dateDebut.toUtc().toIso8601String(),
          "dateFin": dateFin.toUtc().toIso8601String(),
          // "paymentMethod": paymentMethod,
        },
      );

      log('Estimate cost response: ${response.data}');
      return EstimateCostModel.fromJson(response.data);
    } catch (e) {
      log('Error estimating cost: $e');
      rethrow;
    }
  }

  Future<List<DateTime>> getDateBooked({required String residenceId}) async {
    Response rp = await dio.get(
        "${RequestPath.baseUrl}/reservations/data/residence/occupied-dates/$residenceId");
    List data = rp.data['data']['dates'];
    //inspect(data);
    return data.map((element) => DateTime.parse(element['date'])).toList();
  }
}
