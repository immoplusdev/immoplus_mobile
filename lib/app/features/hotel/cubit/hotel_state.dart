import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/remote/hotel/hotel_model.dart';
import '../../../data/models/remote/hotel/hotel_detail_model.dart';
import '../../../data/models/remote/hotel/hotel_estimation_response.dart';
import '../../../data/models/remote/hotel/hotel_villes_response.dart';

part 'hotel_state.freezed.dart';

@freezed
class HotelState with _$HotelState {
  const factory HotelState.initial() = _Initial;
  const factory HotelState.loading() = _Loading;
  const factory HotelState.hotelsLoaded({required List<HotelModel> hotels}) = _HotelsLoaded;
  const factory HotelState.hotelDetailLoaded({required HotelDetailModel hotel}) = _HotelDetailLoaded;
  const factory HotelState.villesLoaded({required List<HotelVillesResponse> villes}) = _VillesLoaded;
  const factory HotelState.estimationLoaded({required HotelEstimationResponse estimation}) = _EstimationLoaded;
  const factory HotelState.error({required String message}) = _Error;
}
