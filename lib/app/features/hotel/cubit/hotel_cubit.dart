import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../data/models/remote/hotel/hotel_estimation_request.dart';
import '../../../data/repositories/hotel_repository.dart';
import 'hotel_state.dart';

@injectable
class HotelCubit extends Cubit<HotelState> {
  final HotelRepository _hotelRepository;

  HotelCubit(this._hotelRepository) : super(const HotelState.initial());

  Future<void> getHotels({
    double? lat,
    double? long,
    double? radius,
    String? villeId,
    bool? isSponsored,
    String? checkInDate,
    String? checkOutDate,
    int? adults,
    int? children,
    int? lits,
  }) async {
    emit(const HotelState.loading());
    try {
      final response = await _hotelRepository.getHotels(
        lat: lat,
        long: long,
        radius: radius,
        villeId: villeId,
        isSponsored: isSponsored,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        adults: adults,
        children: children,
        lits: lits,
      );
      emit(HotelState.hotelsLoaded(hotels: response.data ?? []));
    } catch (e) {
      emit(HotelState.error(message: e.toString()));
    }
  }

  Future<void> getHotel(String id) async {
    emit(const HotelState.loading());
    try {
      final response = await _hotelRepository.getHotel(id);
      emit(HotelState.hotelDetailLoaded(hotel: response));
    } catch (e) {
      emit(HotelState.error(message: e.toString()));
    }
  }

  Future<void> getVilles() async {
    emit(const HotelState.loading());
    try {
      final response = await _hotelRepository.getVilles();
      emit(HotelState.villesLoaded(villes: response));
    } catch (e) {
      emit(HotelState.error(message: e.toString()));
    }
  }

  Future<void> getEstimation({
    required String hotelId,
    required HotelEstimationRequest request,
  }) async {
    emit(const HotelState.loading());
    try {
      final response = await _hotelRepository.getEstimation(
        hotelId: hotelId,
        request: request,
      );
      emit(HotelState.estimationLoaded(estimation: response));
    } catch (e) {
      emit(HotelState.error(message: e.toString()));
    }
  }
}
