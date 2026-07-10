import 'package:freezed_annotation/freezed_annotation.dart';
import 'suggestion_model.dart';

part 'suggest_response.freezed.dart';
part 'suggest_response.g.dart';

@freezed
class SuggestResponse with _$SuggestResponse {
  const factory SuggestResponse({
    String? query,
    int? total,
    @JsonKey(name: 'took_ms') int? tookMs,
    @JsonKey(name: 'from_cache') bool? fromCache,
    @Default([]) List<SuggestionModel> suggestions,
  }) = _SuggestResponse;

  factory SuggestResponse.fromJson(Map<String, dynamic> json) =>
      _$SuggestResponseFromJson(json);
}
