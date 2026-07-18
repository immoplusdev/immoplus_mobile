import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/data/models/remote/reservations/reservation_model.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/logic/request_state.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:immoplus/app/widgets/app_dialog.dart';

@injectable
class PendingPaymentReservationsCubit extends Cubit<RequestState> {
  final ResidenceRepository _repository;

  PendingPaymentReservationsCubit(this._repository)
      : super(const RequestState.initial());

  final PagingController<int, ReservationModel> pagingController =
      PagingController(firstPageKey: 1);

  void init() {
    pagingController.addPageRequestListener(_fetchPage);
  }

  void refreshList() {
    _fetchPage(1);
  }

  Future<void> _fetchPage(int page) async {
    try {
      final result = await _repository.getReservationsEnAttentePaiement(
        page: page,
        perPage: 10,
      );
      result.hasNext == true
          ? pagingController.appendPage(result.data, page + 1)
          : pagingController.appendLastPage(result.data);
    } catch (e) {
      AppDialog.show(
        title: "Erreur de chargement",
        description: "Veuillez vérifier votre connexion internet et réessayer.",
        primaryButtonText: "Fermer",
        onPrimary: () {},
      );
    }
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
