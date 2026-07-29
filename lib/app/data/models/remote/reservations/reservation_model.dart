import 'package:freezed_annotation/freezed_annotation.dart';
import '../residence/residence_model.dart';
import 'client_model.dart';
import 'proprietaire_model.dart';
import 'dates_reservation_model.dart';
import 'status_reservation.dart';
import '../../../enums/rating_status.dart';

part 'reservation_model.freezed.dart';
part 'reservation_model.g.dart';

@freezed
class ReservationModel with _$ReservationModel {
  const factory ReservationModel({
    @Default('') String id,
    @Default('') String statusReservation,
    @Default([]) List<DatesReservationModel> datesReservation,
    @Default('') String dateDebut,
    @Default('') String dateFin,
    @Default('') String statusFacture,
    @Default(false) bool retraitProEffectue,
    @Default(0) double montantTotalReservation,
    @Default(0) double montantReservationSansCommission,
    @Default(0) int montantPaye,
    @Default('') String codeReservation,
    @Default('') String notes,
    @Default('') String clientPhoneNumber,
    @Default('') String createdAt,
    @Default('') String updatedAt,
    @Default(null) String? delaisProprietaireReponse,
    @Default(null) String? delaisPaiementClient,
    @Default(null) bool? ratingsNotified,
    @Default(null) RatingStatus? ratingStatus,
    @Default(null) bool? checkinValide,
    @Default(null) String? checkinValideAt,
    @Default(ResidenceModel()) ResidenceModel residence,
    @Default(ClientModel()) ClientModel client,
    @Default(ProprietaireModel()) ProprietaireModel proprietaire,
  }) = _ReservationModel;

  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationModelFromJson(json);
}

extension ReservationModelX on ReservationModel {
  StatusReservation? get statusEnum =>
      StatusReservation.fromString(statusReservation);

  bool get checkinNotValide => checkinValide != true;
  bool get isCheckinValide => checkinValide == true;
}
