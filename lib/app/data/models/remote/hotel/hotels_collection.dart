import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'hotel_model.dart';

part 'hotels_collection.freezed.dart';
part 'hotels_collection.g.dart';

@freezed
class HotelsCollection with _$HotelsCollection {
  factory HotelsCollection({
    @JsonKey(name: 'resultats') @Default([]) List<HotelModel>? data,
    @JsonKey(fromJson: toInt) int? currentPage,
    @JsonKey(fromJson: toInt) int? totalPages,
    @JsonKey(fromJson: toInt) int? pageSize,
    @Default(false) bool? hasNext,
    @Default(false) bool? hasPrevious,
  }) = _HotelsCollection;

  factory HotelsCollection.fromJson(Map<String, dynamic> json) =>
      _$HotelsCollectionFromJson(json);
}
