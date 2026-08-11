import 'package:freezed_annotation/freezed_annotation.dart';

part 'ad_campaign_model.freezed.dart';
part 'ad_campaign_model.g.dart';

@freezed
class AdCampaignListResponse with _$AdCampaignListResponse {
  const factory AdCampaignListResponse({
    @Default([]) List<AdCampaignModel> data,
  }) = _AdCampaignListResponse;

  factory AdCampaignListResponse.fromJson(Map<String, dynamic> json) =>
      _$AdCampaignListResponseFromJson(json);
}

@freezed
class AdCampaignModel with _$AdCampaignModel {
  const factory AdCampaignModel({
    required int id,
    required String placement,
    @JsonKey(name: 'position_index') int? positionIndex,
    @JsonKey(name: 'campaign_category') String? campaignCategory,
    required String type,
    required AdCampaignContent content,
    required AdCampaignMedia media,
    required String action,
    AdCampaignScope? scope,
    String? url,
    @Default(0) int priority,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    required String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _AdCampaignModel;

  factory AdCampaignModel.fromJson(Map<String, dynamic> json) =>
      _$AdCampaignModelFromJson(json);
}

@freezed
class AdCampaignContent with _$AdCampaignContent {
  const factory AdCampaignContent({
    String? badge,
    String? title,
    String? subtitle,
    @JsonKey(name: 'cta_label') String? ctaLabel,
  }) = _AdCampaignContent;

  factory AdCampaignContent.fromJson(Map<String, dynamic> json) =>
      _$AdCampaignContentFromJson(json);
}

@freezed
class AdCampaignMedia with _$AdCampaignMedia {
  const factory AdCampaignMedia({
    @Default([]) List<String> images,
    @Default([]) List<String> videos,
  }) = _AdCampaignMedia;

  factory AdCampaignMedia.fromJson(Map<String, dynamic> json) =>
      _$AdCampaignMediaFromJson(json);
}

@freezed
class AdCampaignScope with _$AdCampaignScope {
  const factory AdCampaignScope({
    @JsonKey(name: 'entity_id') String? entityId,
    @JsonKey(name: 'entity_ids') @Default([]) List<String> entityIds,
    @Default({}) Map<String, dynamic> filters,
  }) = _AdCampaignScope;

  factory AdCampaignScope.fromJson(Map<String, dynamic> json) =>
      _$AdCampaignScopeFromJson(json);
}
