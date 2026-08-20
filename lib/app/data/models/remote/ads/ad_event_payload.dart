import 'package:freezed_annotation/freezed_annotation.dart';

part 'ad_event_payload.freezed.dart';
part 'ad_event_payload.g.dart';

@freezed
class AdEventPayload with _$AdEventPayload {
  const factory AdEventPayload({
    @JsonKey(name: 'campaign_id') required int campaignId,
    required String placement,
    required String type,
    @JsonKey(name: 'user_id') String? userId,
    required String timestamp,
  }) = _AdEventPayload;

  factory AdEventPayload.fromJson(Map<String, dynamic> json) =>
      _$AdEventPayloadFromJson(json);
}
