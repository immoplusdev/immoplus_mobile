import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_request_body.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_response.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/booking/logic/booking_request_state.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/services/navigation_service.dart';

class BookingCubit extends Cubit<BookingRequestState> {
  BookingCubit() : super(const BookingRequestState.initial());

  // getBookings() async {
  //   emit(const LOADING_BOOKING_LIST());
  //   try {
  //     ReservationsResponse reservationModel =
  //         await LogmentRepository.getReservationsOwner(
  //             id: SessionManager().currentUser!.userId.toString());
  //     inspect(reservationModel);
  //     emit(BookingRequestState.receive(reservationModel));
  //   } catch (e) {
  //     emit(BookingRequestState.error(e.toString()));
  //   }
  // }

  getBooking({required String id}) async {
    emit(const LOADING_BOOKING());
    try {
      ReservationResponse reservationModel =
          await ResidenceRepository().getReservation(id: id);
      emit(BookingRequestState.receiveBooking(reservationModel));
    } catch (e) {
      emit(BookingRequestState.error(e.toString()));
    }
  }

  orderBooking({required ReservationRequestBody body}) async {
    emit(const LOADING_BOOKING());
    try {
      ReservationResponse reservationResponse =
          await ResidenceRepository().createBooking(model: body);
      emit(BookingRequestState.receiveBooking(reservationResponse));

      NavigationService.navigatorKey.currentContext!.goNamed(
        OperatorsSelectorPage.name,
        extra: PaymentPageAdapter(
          itemId: reservationResponse.data.id,
          collection: "reservations",
          amount: reservationResponse.data.montantTotalReservation.toInt(),
        ),
      );
    } catch (e) {
      emit(BookingRequestState.error(e.toString()));
    }
  }
}
