import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/remote/user_preference/user_preference.dart';
import 'package:immoplus/app/data/repositories/user_preference_repository.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomePageCubit extends Cubit<HomePageState> {
  final UserPreferenceRepository _userPreferenceRepository;
  final SessionManager _sessionManager;

  HomePageCubit(this._userPreferenceRepository, this._sessionManager)
      : super(HomePageState(indexPage: 0));

  changeIndex(int index) {
    emit(HomePageState(indexPage: index));
  }

  Future<void> syncUserPreferences() async {
    final user = await _sessionManager.getCurrentUser();
    if (user != null) {
      final localPrefs = await _sessionManager.getLocalPreferences();
      if (localPrefs != null) {
        log('Syncing local preferences to server...');
        try {
          final request = UserPreferenceRequest(
            intentId: localPrefs.intentId,
            propertyTypeIds: localPrefs.propertyTypeIds,
            locationIds: localPrefs.locationIds,
            budgetMin: localPrefs.budgetMin,
            budgetMax: localPrefs.budgetMax,
          );
          await _userPreferenceRepository.updateMyPreferences(request);
          await _sessionManager.clearLocalPreferences();
          log('Local preferences synced and cleared.');
        } catch (e) {
          log('Error syncing preferences: $e');
        }
      }
    }
  }
}
