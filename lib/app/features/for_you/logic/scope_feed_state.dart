import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/enums/home_feed_scope.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_section.dart';
import 'package:immoplus/app/data/models/remote/search_filters/search_filters_response.dart';
import 'package:immoplus/app/features/location_module/data/model/address.dart';

part 'scope_feed_state.freezed.dart';

enum ScopeFeedStatus { initial, loading, success, error }

@freezed
class ScopeFeedState with _$ScopeFeedState {
  const ScopeFeedState._();

  const factory ScopeFeedState({
    required HomeFeedScope scope,
    @Default(ScopeFeedStatus.initial) ScopeFeedStatus status,
    @Default([]) List<HomeFeedSection> sections,
    @Default(false) bool hasMore,
    String? nextCursor,
    @Default(false) bool isLoadingMore,
    SearchFiltersData? filtersData,
    @Default({}) Map<String, SearchFilterOption?> selectedFilters,
    Address? selectedAddress,
    DateTimeRange? selectedDateRange,
    String? errorMessage,
  }) = _ScopeFeedState;

  bool get isStay => scope.isStay;
  bool get isRent => scope.isRent;
  bool get isBuy => scope.isBuy;
}
