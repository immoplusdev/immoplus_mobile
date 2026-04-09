import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/data/models/auth/demande_pro_particulier_body.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';
import 'become_pro_state.dart';

class BecomeProCubit extends Cubit<BecomeProState> {
  BecomeProCubit() : super(BecomeProInitial());

  Future<void> submitDemande({
    required String activite,
    required String photoIdentiteId,
    required String pieceIdentiteId,
  }) async {
    emit(BecomeProLoading());
    try {
      final body = DemandeProParticulierBody(
        activite: activite,
        photoIdentiteId: photoIdentiteId,
        pieceIdentiteId: pieceIdentiteId,
      );
      
      await AuthRepository().createDemandeProParticulier(body: body);
      
      emit(BecomeProSuccess());
    } catch (e) {
      emit(BecomeProFailure(e.toString()));
    }
  }
}
