import 'package:immoplus/app/core/error/error_feedback.dart';
import 'package:immoplus/app/core/error/error_messages.dart';
import 'package:immoplus/app/core/error/error_context.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/data/models/remote/bienimmobilier/bien_immobilier_single.dart';
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus/app/logic/request_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class EstateCubit extends Cubit<RequestState> {
  final BienImmobilierRepository bienImmobilierRepository;

  EstateCubit(this.bienImmobilierRepository) : super(const REQUEST_INITIAL());

  getEstate({required String id}) async {
    emit(const REQUEST_LOADING());
    try {
      BienImmobilierSingle residenceResponse =
          await bienImmobilierRepository.getBiensImmobilier(id);

      if (residenceResponse.data != null) {
        emit(RequestState.bienImmobilier(data: residenceResponse.data!));
      } else {
        emit(const REQUEST_INITIAL());
      }
    } catch (e) {
      ErrorFeedback.show(e, context: ErrorContext.listingLoad);
      emit(RequestState.error(
          error: ErrorMessages.messageOf(e, ErrorContext.listingLoad)));
    }
  }
}
