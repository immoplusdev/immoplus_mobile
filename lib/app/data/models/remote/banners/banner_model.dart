import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner_model.freezed.dart';
part 'banner_model.g.dart';

@freezed
class BannerResponse with _$BannerResponse {
  const factory BannerResponse({
    @Default([]) List<BannerModel> data,
  }) = _BannerResponse;

  factory BannerResponse.fromJson(Map<String, dynamic> json) =>
      _$BannerResponseFromJson(json);
}

@freezed
class BannerModel with _$BannerModel {
  const factory BannerModel({
    int? id,
    String? title,
    String? subtitle,
    @JsonKey(name: 'cta_label') String? ctaLabel,
    @JsonKey(name: 'cta_url') String? ctaUrl,
    @JsonKey(name: 'cta2_label') String? cta2Label,
    @JsonKey(name: 'cta2_url') String? cta2Url,
    String? icon,
    @JsonKey(name: 'bg_color') String? bgColor,
    @JsonKey(name: 'text_color') String? textColor,
    String? type,
    String? audience,
    int? order,
    bool? active,
    bool? dismissible,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) = _BannerModel;

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);
}
