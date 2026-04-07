import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/enums/contact_change_type.dart';
import 'package:immoplus/app/data/models/local/user_model_schema.dart';
import 'package:immoplus/app/data/models/remote/user/contact_change_models.dart';
import 'package:immoplus/app/data/repositories/auth_repository.dart';
import 'package:immoplus/app/utils/phone_number_handler.dart';

import 'contact_change_state.dart';

class ContactChangeCubit extends Cubit<ContactChangeState> {
  ContactChangeCubit() : super(ContactChangeInitial());

  final _sessionManager = getIt<SessionManager>();

  Future<void> requestChange({
    required ContactChangeType type,
    String? phoneNumber,
    String? email,
  }) async {
    emit(ContactChangeRequestLoading());
    try {
      final body = RequestContactChangeBody(
        type: type.toJson,
        phoneNumber: type == ContactChangeType.phone && phoneNumber != null
            ? PhoneNumberHandler.formatPhoneNumber(phoneNumber)
            : null,
        email: type == ContactChangeType.email ? email : null,
      );
      await AuthRepository().requestContactChange(body);
      emit(ContactChangeRequestSuccess(type));
    } catch (e) {
      emit(ContactChangeRequestError(e.toString()));
    }
  }

  Future<void> confirmChange({
    required ContactChangeType type,
    required String code,
  }) async {
    emit(ContactChangeConfirmLoading());
    try {
      final body = ConfirmContactChangeBody(
        type: type.toJson,
        code: code,
      );
      final response = await AuthRepository().confirmContactChange(body);
      final user = response.data;
      await _sessionManager.saveUser(
        UserModelSchema()
          ..id = 1
          ..userId = user.id
          ..firstName = user.firstName
          ..lastName = user.lastName
          ..email = user.email
          ..phoneNumber = user.phoneNumber
          ..avatar = user.avatar
          ..role = user.role.name
          ..roleName = user.role.name
          ..activite = user.additionalData.activite
          ..nomEntreprise = user.additionalData.nomEntreprise
          ..emailEntreprise = user.additionalData.emailEntreprise
          ..accessToken = _sessionManager.currentUser?.accessToken
          ..refreshToken = _sessionManager.currentUser?.refreshToken,
      );
      await _sessionManager.getCurrentUser();
      emit(ContactChangeConfirmSuccess(
          "Votre contact a été mis à jour avec succès."));
    } catch (e) {
      emit(ContactChangeConfirmError(e.toString()));
    }
  }
}
