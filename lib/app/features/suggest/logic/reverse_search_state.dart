import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/reverse_search/reverse_search_model.dart';

part 'reverse_search_state.freezed.dart';

@freezed
class ReverseSearchState with _$ReverseSearchState {
  const factory ReverseSearchState.initial() = _Initial;
  const factory ReverseSearchState.loading() = _Loading;
  const factory ReverseSearchState.searching({
    required String searchId,
    @Default([]) List<ReverseSearchProposition> propositions,
  }) = _Searching;
  const factory ReverseSearchState.locked({
    required String searchId,
    required ReverseSearchProposition proposition,
  }) = _Locked;
  const factory ReverseSearchState.error(String message) = _Error;
}
