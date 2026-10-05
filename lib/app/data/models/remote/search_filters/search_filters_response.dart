import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_filters_response.freezed.dart';
part 'search_filters_response.g.dart';

@freezed
class SearchFiltersResponse with _$SearchFiltersResponse {
  const factory SearchFiltersResponse({
    required SearchFiltersData data,
  }) = _SearchFiltersResponse;

  factory SearchFiltersResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchFiltersResponseFromJson(json);
}

@freezed
class SearchFiltersData with _$SearchFiltersData {
  const factory SearchFiltersData({
    required String scope,
    @Default([]) List<SearchFilterItem> filters,
    SearchRadiusConfig? radius,
    @Default([]) List<SearchSortOption> sorts,
  }) = _SearchFiltersData;

  factory SearchFiltersData.fromJson(Map<String, dynamic> json) =>
      _$SearchFiltersDataFromJson(json);
}

@freezed
class SearchFilterItem with _$SearchFilterItem {
  const factory SearchFilterItem({
    required String key,
    required String kind,
    required String label,
    @Default(false) bool primary,
    @Default([]) List<String> params,
    @Default(true) bool allowAll,
    String? currency,
    String? period,
    @Default([]) List<SearchFilterOption> options,
  }) = _SearchFilterItem;

  factory SearchFilterItem.fromJson(Map<String, dynamic> json) =>
      _$SearchFilterItemFromJson(json);
}

@freezed
class SearchFilterOption with _$SearchFilterOption {
  const factory SearchFilterOption({
    required dynamic value,
    required String label,
    @Default({}) Map<String, dynamic> params,
  }) = _SearchFilterOption;

  factory SearchFilterOption.fromJson(Map<String, dynamic> json) =>
      _$SearchFilterOptionFromJson(json);
}

@freezed
class SearchRadiusConfig with _$SearchRadiusConfig {
  const factory SearchRadiusConfig({
    @JsonKey(name: 'default') @Default(15) int defaultValue,
    @Default(100) int max,
    @Default('km') String unit,
  }) = _SearchRadiusConfig;

  factory SearchRadiusConfig.fromJson(Map<String, dynamic> json) =>
      _$SearchRadiusConfigFromJson(json);
}

@freezed
class SearchSortOption with _$SearchSortOption {
  const factory SearchSortOption({
    required String value,
    required String label,
  }) = _SearchSortOption;

  factory SearchSortOption.fromJson(Map<String, dynamic> json) =>
      _$SearchSortOptionFromJson(json);
}
