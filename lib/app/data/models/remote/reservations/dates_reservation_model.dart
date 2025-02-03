import 'package:freezed_annotation/freezed_annotation.dart';

part 'dates_reservation_model.freezed.dart';
part 'dates_reservation_model.g.dart';

@freezed
class DatesReservationModel with _$DatesReservationModel {
  const factory DatesReservationModel({
    @Default(null) DateTime? date,
  }) = _DatesReservationModel;

  factory DatesReservationModel.fromJson(Map<String, dynamic> json) =>
      _$DatesReservationModelFromJson(json);
}
