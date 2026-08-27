import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';

part 'ads_state.freezed.dart';
part 'ads_state.g.dart';

@freezed
class AdsState with _$AdsState {
  const factory AdsState.initial() = ADS_INITIAL;
  const factory AdsState.loading() = ADS_LOADING;
  const factory AdsState.error({required String message}) = ADS_ERROR;
  const factory AdsState.success({required List<AdCampaignModel> campaigns}) = ADS_SUCCESS;

  factory AdsState.fromJson(Map<String, dynamic> json) =>
      _$AdsStateFromJson(json);
}
