import 'package:freezed_annotation/freezed_annotation.dart';
import '../residence/residence_model.dart';
import 'client_model.dart';
import 'proprietaire_model.dart';
import 'dates_reservation_model.dart';
part 'reservation_model.freezed.dart';
part 'reservation_model.g.dart';

@freezed
class ReservationModel with _$ReservationModel {
  const factory ReservationModel({
    @Default('') String id,
    @Default('') String statusReservation,
    @Default([]) List<DatesReservationModel> datesReservation,
    @Default('') String statusFacture,
    @Default(false) bool retraitProEffectue,
    @Default(0) double montantTotalReservation,
    @Default(0) double montantReservationSansCommission,
    @Default('') String notes,
    @Default('') String clientPhoneNumber,
    @Default('') String createdAt,
    @Default('') String updatedAt,
    @Default(ResidenceModel()) ResidenceModel residence,
    @Default(ClientModel()) ClientModel client,
    @Default(ProprietaireModel()) ProprietaireModel proprietaire,
  }) = _ReservationModel;

  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationModelFromJson(json);
}
