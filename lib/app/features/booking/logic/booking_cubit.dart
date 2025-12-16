import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_request_body.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_response.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/features/booking/data/estimate_price_model.dart';
import 'package:immoplus/app/features/booking/logic/booking_request_state.dart';
import 'package:immoplus/app/features/booking/logic/booking_services.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookingCubit extends Cubit<BookingRequestState> {
  BookingServices bookingServices;
  ResidenceRepository residenceRepository;

  BookingCubit(this.bookingServices, this.residenceRepository)
      : super(const BookingRequestState.initial());

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
          await residenceRepository.getReservation(id: id);
      emit(BookingRequestState.receiveBooking(reservationModel));
    } catch (e) {
      emit(BookingRequestState.error(e.toString()));
    }
  }

  estimatePrice(
      {required String residenceId, required List<DateTime> dates}) async {
    emit(const LOADING_BOOKING());
    try {
      EstimatePriceModel reservationModel = await bookingServices.estimerPrix(
          residenceId: residenceId, dates: dates);
      emit(BookingRequestState.receiveEstimation(reservationModel));
    } catch (e) {
      emit(INITIAL_BOOKING());
      emit(BookingRequestState.error(e.toString()));
    }
  }

  estimateCost({
    required String residenceId,
    required DateTime dateDebut,
    required DateTime dateFin,
    // String paymentMethod = 'moov',
  }) async {
    emit(const LOADING_BOOKING());
    try {
      final estimation = await bookingServices.estimateCost(
        residenceId: residenceId,
        dateDebut: dateDebut,
        dateFin: dateFin,
        // paymentMethod: paymentMethod,
      );
      emit(BookingRequestState.receiveEstimateCost(estimation));
    } catch (e) {
      emit(const INITIAL_BOOKING());
      emit(BookingRequestState.error(e.toString()));
    }
  }

  orderBooking(
      {required ReservationRequestBody body, required int amount}) async {
    emit(const LOADING_BOOKING());
    try {
      ReservationResponse reservationResponse =
          await residenceRepository.createBooking(model: body);
      emit(BookingRequestState.receiveBooking(reservationResponse));

      NavigationService.navigatorKey.currentContext!.pushNamed(
        OperatorsSelectorPage.name,
        extra: PaymentPageAdapter(
          itemId: reservationResponse.data.id,
          collection: ProductType.reservations.name,
          amount: amount,

          // amount: reservationResponse.data.montantTotalReservation.toInt(),
        ),
      );
    } catch (e) {
      emit(BookingRequestState.error(e.toString()));
    }
  }
}
