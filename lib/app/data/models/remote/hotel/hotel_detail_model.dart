import 'package:freezed_annotation/freezed_annotation.dart';
import 'hotel_model.dart';

part 'hotel_detail_model.freezed.dart';
part 'hotel_detail_model.g.dart';

@freezed
class HotelDetailModel with _$HotelDetailModel {
  const HotelDetailModel._();

  factory HotelDetailModel({
    @Default('') String hotelId,
    @Default('') String nom,
    @Default('') String type,
    @Default(0) int etoiles,
    @Default('') String ville,
    @Default('') String adresse,
    @Default('') String descriptionCourte,
    @Default('') String descriptionLongue,
    @Default([]) List<String> images,
    @Default('') String videoFileId,
    @Default(HotelAmenities()) HotelAmenities amenities,
    @Default('') String heureArrivee,
    @Default('') String heureDepart,
    @Default(0) int tauxAcompte,
    @Default(0) int taxeSejour,
    @Default(false) bool estSponsorise,
    @Default([]) List<RoomTypeModel> typesChambres,
  }) = _HotelDetailModel;

  double get firstRoomPrice {
    if (typesChambres.isNotEmpty) {
      return typesChambres.first.prixAPartirDe.toDouble();
    }
    return taxeSejour.toDouble();
  }

  factory HotelDetailModel.fromJson(Map<String, dynamic> json) =>
      _$HotelDetailModelFromJson(json);
}

@freezed
class RoomTypeModel with _$RoomTypeModel {
  factory RoomTypeModel({
    @Default('') String roomTypeId,
    @Default('') String nom,
    @Default(0) int prixAPartirDe,
    @Default(0) int occupationMax,
    @Default(0) int nombreChambres,
    @Default([]) List<String> images,
  }) = _RoomTypeModel;

  factory RoomTypeModel.fromJson(Map<String, dynamic> json) =>
      _$RoomTypeModelFromJson(json);
}
