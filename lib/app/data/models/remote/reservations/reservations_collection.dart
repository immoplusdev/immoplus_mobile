import 'package:freezed_annotation/freezed_annotation.dart';
import 'reservation_model.dart';

part 'reservations_collection.freezed.dart';
part 'reservations_collection.g.dart';

@freezed
class ReservationsCollection with _$ReservationsCollection {
  factory ReservationsCollection({
    @Default([]) List<ReservationModel> data,
    @Default(1) int currentPage,
    @Default(1) int totalPages,
    @Default(10) int pageSize,
    @Default(0) int totalCount,
    @Default(false) bool hasNext,
    @Default(false) bool hasPrevious,
  }) = _ReservationsCollection;

  factory ReservationsCollection.fromJson(Map<String, dynamic> json) =>
      _$ReservationsCollectionFromJson(json);
}
