import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../data/repositories/hotel_repository.dart';
import 'hotel_room_state.dart';

@injectable
class HotelRoomCubit extends Cubit<HotelRoomState> {
  final HotelRepository _hotelRepository;

  HotelRoomCubit(this._hotelRepository) : super(const HotelRoomState.initial());

  Future<void> getRoomDetail(String hotelId, String roomTypeId) async {
    emit(const HotelRoomState.loading());
    try {
      final response = await _hotelRepository.getRoomDetail(hotelId, roomTypeId);
      emit(HotelRoomState.loaded(roomDetail: response));
    } catch (e) {
      emit(HotelRoomState.error(message: e.toString()));
    }
  }
}
