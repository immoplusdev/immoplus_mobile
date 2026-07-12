import 'package:freezed_annotation/freezed_annotation.dart';

part 'suggest_click_payload.freezed.dart';
part 'suggest_click_payload.g.dart';

@freezed
class SuggestClickPayload with _$SuggestClickPayload {
  const factory SuggestClickPayload({
    required String query,
    required String type,
    required String id,
  }) = _SuggestClickPayload;

  factory SuggestClickPayload.fromJson(Map<String, dynamic> json) =>
      _$SuggestClickPayloadFromJson(json);
}
