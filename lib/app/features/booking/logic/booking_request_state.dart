import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_response.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservations_collection.dart';

part 'booking_request_state.freezed.dart';

@freezed
class BookingRequestState with _$BookingRequestState {
  const factory BookingRequestState.initial() = INITIAL_BOOKING;
  const factory BookingRequestState.loading() = LOADING_BOOKING;
  const factory BookingRequestState.loadingList() = LOADING_BOOKING_LIST;
  const factory BookingRequestState.receive(
      ReservationsCollection reservationResponse) = RECEIVE_BOOKINGS;
  const factory BookingRequestState.receiveBooking(
      ReservationResponse reservationResponse) = RECEIVE_BOOKING;
  const factory BookingRequestState.error(String message) = Error_BOOKINGS;
}
