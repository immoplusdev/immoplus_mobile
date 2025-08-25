import 'package:freezed_annotation/freezed_annotation.dart';

part 'estimate_price_model.freezed.dart';
part 'estimate_price_model.g.dart';

@freezed
class EstimatePriceModel with _$EstimatePriceModel {
  const factory EstimatePriceModel({
    EstimatePriceData? data,
  }) = _EstimatePriceModel;

  factory EstimatePriceModel.fromJson(Map<String, dynamic> json) =>
      _$EstimatePriceModelFromJson(json);
}

@freezed
class EstimatePriceData with _$EstimatePriceData {
  const factory EstimatePriceData({
    @Default('') String residence,
    @Default([]) List<ReservationDate> datesReservation,
    @Default(0) double montantTotalReservation,
    @Default(0) double montantReservationSansCommission,
  }) = _EstimatePriceData;

  factory EstimatePriceData.fromJson(Map<String, dynamic> json) =>
      _$EstimatePriceDataFromJson(json);
}

@freezed
class ReservationDate with _$ReservationDate {
  const factory ReservationDate({
    DateTime? date,
  }) = _ReservationDate;

  factory ReservationDate.fromJson(Map<String, dynamic> json) =>
      _$ReservationDateFromJson(json);
}
