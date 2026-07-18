import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/remote/hotel/hotel_room_detail_model.dart';

part 'hotel_room_state.freezed.dart';

@freezed
class HotelRoomState with _$HotelRoomState {
  const factory HotelRoomState.initial() = _Initial;
  const factory HotelRoomState.loading() = _Loading;
  const factory HotelRoomState.loaded({required HotelRoomDetailModel roomDetail}) = _Loaded;
  const factory HotelRoomState.error({required String message}) = _Error;
}
