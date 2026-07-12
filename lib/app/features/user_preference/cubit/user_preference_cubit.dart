import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/data/models/local/user_preference_schema.dart';
import 'package:immoplus/app/data/repositories/user_preference_repository.dart';
import 'package:immoplus/app/features/user_preference/cubit/user_preference_cubit_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserPreferenceCubit extends Cubit<UserPreferenceCubitState> {
  final UserPreferenceRepository _repository;
  final SessionManager _sessionManager;

  UserPreferenceCubit(this._repository, this._sessionManager)
      : super(const UserPreferenceCubitState.initial());

  Future<void> init({String? userId}) async {
    emit(const UserPreferenceCubitState.loading());
    try {
      final optionsResponse = await _repository.getOptions();
      final options = optionsResponse.data.data;

      List<String> selectedTypes = [];
      List<String> selectedLocations = [];
      String? selectedIntentId;
      double? budgetMin;
      double? budgetMax;

      if (userId != null) {
        try {
          final myPrefsResponse = await _repository.getMyPreferences();
          final myPrefs = myPrefsResponse.data;
          selectedTypes =
              myPrefs?.propertyTypes.map((e) => e.id).toList() ?? [];
          selectedLocations =
              myPrefs?.locations.map((e) => e.id).toList() ?? [];
          selectedIntentId = myPrefs?.intent?.id;
          budgetMin = myPrefs?.budgetMin;
          budgetMax = myPrefs?.budgetMax;
        } catch (e) {
          log('Error fetching user preferences: $e');
        }
      } else {
        // Load local preferences if any
        final localPrefs = await _sessionManager.getLocalPreferences();
        if (localPrefs != null) {
          selectedTypes = localPrefs.propertyTypeIds;
          selectedLocations = localPrefs.locationIds;
          selectedIntentId = localPrefs.intentId;
          budgetMin = localPrefs.budgetMin;
          budgetMax = localPrefs.budgetMax;
        }
      }

      emit(UserPreferenceCubitState.loaded(
        options: options,
        selectedIntentId: selectedIntentId,
        selectedPropertyTypeIds: selectedTypes,
        selectedLocationIds: selectedLocations,
        budgetMin: budgetMin,
        budgetMax: budgetMax,
      ));
    } catch (e) {
      emit(UserPreferenceCubitState.error(e.toString()));
    }
  }

  void selectIntent(String id) {
    state.maybeWhen(
      loaded: (options, selectedIntentId, selectedPropertyTypeIds,
          selectedLocationIds, budgetMin, budgetMax, isSaving) {
        emit(UserPreferenceCubitState.loaded(
          options: options,
          selectedIntentId: id,
          selectedPropertyTypeIds: selectedPropertyTypeIds,
          selectedLocationIds: selectedLocationIds,
          budgetMin: budgetMin,
          budgetMax: budgetMax,
          isSaving: isSaving,
        ));
      },
      orElse: () {},
    );
  }

  void togglePropertyType(String id) {
    state.maybeWhen(
      loaded: (options, selectedIntentId, selectedPropertyTypeIds,
          selectedLocationIds, budgetMin, budgetMax, isSaving) {
        final newList = List<String>.from(selectedPropertyTypeIds);
        if (newList.contains(id)) {
          newList.remove(id);
        } else {
          newList.add(id);
        }
        emit(UserPreferenceCubitState.loaded(
          options: options,
          selectedIntentId: selectedIntentId,
          selectedPropertyTypeIds: newList,
          selectedLocationIds: selectedLocationIds,
          budgetMin: budgetMin,
          budgetMax: budgetMax,
          isSaving: isSaving,
        ));
      },
      orElse: () {},
    );
  }

  void toggleLocation(String id) {
    state.maybeWhen(
      loaded: (options, selectedIntentId, selectedPropertyTypeIds,
          selectedLocationIds, budgetMin, budgetMax, isSaving) {
        final newList = List<String>.from(selectedLocationIds);
        if (newList.contains(id)) {
          newList.remove(id);
        } else {
          newList.add(id);
        }
        emit(UserPreferenceCubitState.loaded(
          options: options,
          selectedIntentId: selectedIntentId,
          selectedPropertyTypeIds: selectedPropertyTypeIds,
          selectedLocationIds: newList,
          budgetMin: budgetMin,
          budgetMax: budgetMax,
          isSaving: isSaving,
        ));
      },
      orElse: () {},
    );
  }

  void updateBudget(double? min, double? max) {
    state.maybeWhen(
      loaded: (options, selectedIntentId, selectedPropertyTypeIds,
          selectedLocationIds, budgetMin, budgetMax, isSaving) {
        emit(UserPreferenceCubitState.loaded(
          options: options,
          selectedIntentId: selectedIntentId,
          selectedPropertyTypeIds: selectedPropertyTypeIds,
          selectedLocationIds: selectedLocationIds,
          budgetMin: min,
          budgetMax: max,
          isSaving: isSaving,
        ));
      },
      orElse: () {},
    );
  }

  Future<void> save() async {
    state.maybeWhen(
      loaded: (options, selectedIntentId, selectedPropertyTypeIds,
          selectedLocationIds, budgetMin, budgetMax, isSaving) async {
        emit(UserPreferenceCubitState.loaded(
          options: options,
          selectedIntentId: selectedIntentId,
          selectedPropertyTypeIds: selectedPropertyTypeIds,
          selectedLocationIds: selectedLocationIds,
          budgetMin: budgetMin,
          budgetMax: budgetMax,
          isSaving: true,
        ));

        try {
          // Save locally in Isar
          final localPrefs = UserPreferenceSchema()
            ..intentId = selectedIntentId
            ..propertyTypeIds = selectedPropertyTypeIds
            ..locationIds = selectedLocationIds
            ..budgetMin = budgetMin
            ..budgetMax = budgetMax
            ..createdAt = DateTime.now();

          await _sessionManager.saveLocalPreferences(localPrefs);
          await _sessionManager.markOnboardingAsRead();
          emit(const UserPreferenceCubitState.success());
        } catch (e) {
          emit(UserPreferenceCubitState.loaded(
            options: options,
            selectedIntentId: selectedIntentId,
            selectedPropertyTypeIds: selectedPropertyTypeIds,
            selectedLocationIds: selectedLocationIds,
            budgetMin: budgetMin,
            budgetMax: budgetMax,
            isSaving: false,
          ));
        }
      },
      orElse: () {},
    );
  }
}
