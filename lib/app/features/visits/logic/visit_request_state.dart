import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/demande_visit_response.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_response.dart';

part 'visit_request_state.freezed.dart';

@freezed
class VisitRequestState with _$VisitRequestState {
  const factory VisitRequestState.initial() = INITIAL_VISITS;
  const factory VisitRequestState.loading() = LOADING_VISITS;
  const factory VisitRequestState.loadingList() = LOADING_VISITS_LIST;
  const factory VisitRequestState.receive(
      DemandeVisiteModel demandeVisitModel) = RECEIVE_VISITS;
  const factory VisitRequestState.receiveId(
      DemandeVisitResponse demandeVisitResponse) = RECEIVE_VISIT;
  const factory VisitRequestState.error(String message) = Error_VISITSS;
}
