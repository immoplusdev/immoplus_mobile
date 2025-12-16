import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_response.dart';
import 'package:immoplus/app/data/repositories/residence_repository.dart';
import 'package:immoplus/app/logic/request_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResidenceCubit extends Cubit<RequestState> {
  final ResidenceRepository residenceRepository;
  ResidenceCubit(this.residenceRepository) : super(const REQUEST_INITIAL());

  getResidence({required String id}) async {
    emit(const REQUEST_LOADING());
    try {
      ResidenceResponse residenceResponse =
          await residenceRepository.getResidence(id);

      emit(RequestState.residence(data: residenceResponse.data));
    } catch (e) {
      emit(RequestState.error(error: e.toString()));
    }
  }
}
