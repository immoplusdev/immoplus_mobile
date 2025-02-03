import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/services/navigation_service.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/demande_visit_request_body.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/demande_visit_response.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/features/visits/logic/visit_request_state.dart';

class VisitCubit extends Cubit<VisitRequestState> {
  VisitCubit() : super(const VisitRequestState.initial());

  getVisits() async {
    emit(const LOADING_VISITS_LIST());
    // try {
    //   ReservationModel reservationModel =
    //       await LogmentRepository.getReservations(
    //           id: UserModel.singleton.id.toString());
    //   emit(VisitRequestState.receive(reservationModel));
    // } catch (e) {
    //   emit(VisitRequestState.error(e.toString()));
    // }
  }

  getVisit({required String id}) async {
    emit(const LOADING_VISITS());
    try {
      DemandeVisitResponse reservationModel =
          await BienImmobilierRepository().getVisit(id: id);
      emit(VisitRequestState.receiveId(reservationModel));
    } catch (e) {
      emit(VisitRequestState.error(e.toString()));
    }
  }

  visitRequest({required DemandeVisitRequestBody body}) async {
    emit(const LOADING_VISITS());
    try {
      DemandeVisitResponse demandeVisitResponse =
          await BienImmobilierRepository().createVisit(model: body);
      emit(VisitRequestState.receive(demandeVisitResponse.data));
      NavigationService.navigatorKey.currentContext!.goNamed(
        OperatorsSelectorPage.name,
        extra: PaymentPageAdapter(
          itemId: demandeVisitResponse.data.id,
          collection: "demandes_visites",
          amount: demandeVisitResponse.data.montantTotalDemandeVisite.toInt(),
        ),
      );
    } catch (e) {
      emit(VisitRequestState.error(e.toString()));
    }
  }
}
