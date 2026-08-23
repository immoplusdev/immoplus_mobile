import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/reverse_search/reverse_search_model.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';

part 'reverse_search_state.freezed.dart';

@freezed
class ReverseSearchState with _$ReverseSearchState {
  const factory ReverseSearchState.initial() = _Initial;
  const factory ReverseSearchState.loading() = _Loading;
  const factory ReverseSearchState.searching({
    required String searchId,
    @Default([]) List<ReverseSearchProposition> propositions,
    @Default([]) List<ResidenceModel> classicResidences,
    // Résidence sélectionnée en attente de paiement (verrouillée le temps du
    // paiement). Épinglée dans la liste "Libre tout de suite" côté UI.
    ReverseSearchProposition? pendingSelection,
    DateTime? selectionExpireAt,
  }) = _Searching;
  const factory ReverseSearchState.error(String message) = _Error;
}
