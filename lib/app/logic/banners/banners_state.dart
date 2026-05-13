import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/banners/banner_model.dart';

part 'banners_state.freezed.dart';
part 'banners_state.g.dart';

@freezed
class BannersState with _$BannersState {
  const factory BannersState.initial() = BANNERS_INITIAL;
  const factory BannersState.loading() = BANNERS_LOADING;
  const factory BannersState.error({required String message}) = BANNERS_ERROR;
  const factory BannersState.success({required List<BannerModel> banners}) =
      BANNERS_SUCCESS;

  factory BannersState.fromJson(Map<String, dynamic> json) =>
      _$BannersStateFromJson(json);
}
