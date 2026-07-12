import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/logger/immo_logger.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:immoplus/app/core/services/navigation_service.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/demande_visit_request_body.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/demande_visit_response.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/features/visits/logic/visit_request_state.dart';
import 'package:immoplus/app/widgets/custom_popup.dart';
import 'package:injectable/injectable.dart';

@injectable
class VisitCubit extends Cubit<VisitRequestState> {
  final BienImmobilierRepository bienImmobilierRepository;

  VisitCubit(this.bienImmobilierRepository)
      : super(const VisitRequestState.initial());

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
          await bienImmobilierRepository.getVisit(id: id);
      emit(VisitRequestState.receiveId(reservationModel));
    } catch (e) {
      emit(VisitRequestState.error(e.toString()));
    }
  }

  visitRequest({required DemandeVisitRequestBody body}) async {
    emit(const LOADING_VISITS());
    try {
      CustomPopup.showLoagingToast();
      DemandeVisitResponse demandeVisitResponse =
          await bienImmobilierRepository.createVisit(model: body);
      getIt<AnalyticsService>().logVisitRequestSubmitted(
        estateId: body.bienImmobilier,
        estateName: demandeVisitResponse.data.bienImmobilier?.nom ?? '',
      );
      emit(VisitRequestState.receive(demandeVisitResponse.data));
    } catch (e, s) {
      log(s.toString());
      emit(VisitRequestState.error(e.toString()));
    } finally {
      CustomPopup.hideLoadingToast();
    }
  }
}
