import 'package:freezed_annotation/freezed_annotation.dart';

part 'hotel_room_detail_model.freezed.dart';
part 'hotel_room_detail_model.g.dart';

@freezed
class HotelRoomDetailModel with _$HotelRoomDetailModel {
  factory HotelRoomDetailModel({
    @Default('') String roomTypeId,
    @Default('') String hotelId,
    @Default('') String nom,
    String? description,
    String? vue,
    @Default('') String typeLit,
    @Default(0) int nombreLits,
    @Default(0) int occupationMax,
    @Default([]) List<String> images,
    @Default(RoomTarification()) RoomTarification tarification,
    @Default(1) int sejourMin,
    int? sejourMax,
    @Default(RoomBreakfast()) RoomBreakfast petitDejeuner,
    @Default(RoomCancellationPolicy()) RoomCancellationPolicy politiqueAnnulation,
  }) = _HotelRoomDetailModel;

  factory HotelRoomDetailModel.fromJson(Map<String, dynamic> json) =>
      _$HotelRoomDetailModelFromJson(json);
}

@freezed
class RoomTarification with _$RoomTarification {
  const factory RoomTarification({
    @Default(0) int prixParNuit,
    int? prixWeekend,
    int? prixLongSejour,
    @Default('XOF') String devise,
  }) = _RoomTarification;

  factory RoomTarification.fromJson(Map<String, dynamic> json) =>
      _$RoomTarificationFromJson(json);
}

@freezed
class RoomBreakfast with _$RoomBreakfast {
  const factory RoomBreakfast({
    @Default('') String option,
    @Default(0) int prix,
  }) = _RoomBreakfast;

  factory RoomBreakfast.fromJson(Map<String, dynamic> json) =>
      _$RoomBreakfastFromJson(json);
}

@freezed
class RoomCancellationPolicy with _$RoomCancellationPolicy {
  const factory RoomCancellationPolicy({
    @Default('') String code,
    @Default('') String libelle,
  }) = _RoomCancellationPolicy;

  factory RoomCancellationPolicy.fromJson(Map<String, dynamic> json) =>
      _$RoomCancellationPolicyFromJson(json);
}
