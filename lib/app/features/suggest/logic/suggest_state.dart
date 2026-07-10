import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/remote/suggest/suggestion_model.dart';

part 'suggest_state.freezed.dart';

@freezed
class SuggestState with _$SuggestState {
  const factory SuggestState.initial() = _Initial;
  const factory SuggestState.loading() = _Loading;
  const factory SuggestState.success(List<SuggestionModel> suggestions) = _Success;
  const factory SuggestState.error(String message) = _Error;
}
