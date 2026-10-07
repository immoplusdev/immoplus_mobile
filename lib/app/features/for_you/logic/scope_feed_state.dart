import 'package:flutter/material.dart';
import 'package:immoplus/app/data/enums/home_feed_scope.dart';
import 'package:immoplus/app/data/models/remote/search_filters/scope_search_response.dart';
import 'package:immoplus/app/data/models/remote/search_filters/search_filters_response.dart';
import 'package:immoplus/app/features/location_module/data/model/address.dart';

enum ScopeFeedStatus { initial, loading, success, error }

/// État unifié des onglets Location, Achat et Séjour (ONG.MD).
///
/// Il ne dépend volontairement d'aucun fichier généré ; le flux peut donc être
/// exécuté immédiatement après un checkout du projet.
class ScopeFeedState {
  const ScopeFeedState({
    required this.scope,
    this.status = ScopeFeedStatus.initial,
    this.items = const [],
    this.nextCursor,
    this.hasMore = false,
    this.totalCount = 0,
    this.isLoadingMore = false,
    this.filtersData,
    this.selectedFilters = const {},
    this.selectedAddress,
    this.selectedDateRange,
    this.guests,
    this.errorMessage,
  });

  final HomeFeedScope scope;
  final ScopeFeedStatus status;
  final List<ScopeSearchItem> items;
  final String? nextCursor;
  final bool hasMore;
  final int totalCount;
  final bool isLoadingMore;
  final SearchFiltersData? filtersData;
  final Map<String, SearchFilterOption?> selectedFilters;
  final Address? selectedAddress;
  final DateTimeRange? selectedDateRange;
  final int? guests;
  final String? errorMessage;

  bool get isStay => scope.isStay;
  bool get isRent => scope.isRent;
  bool get isBuy => scope.isBuy;

  ScopeFeedState copyWith({
    HomeFeedScope? scope,
    ScopeFeedStatus? status,
    List<ScopeSearchItem>? items,
    Object? nextCursor = _unset,
    bool? hasMore,
    int? totalCount,
    bool? isLoadingMore,
    Object? filtersData = _unset,
    Map<String, SearchFilterOption?>? selectedFilters,
    Object? selectedAddress = _unset,
    Object? selectedDateRange = _unset,
    Object? guests = _unset,
    Object? errorMessage = _unset,
  }) {
    return ScopeFeedState(
      scope: scope ?? this.scope,
      status: status ?? this.status,
      items: items ?? this.items,
      nextCursor: identical(nextCursor, _unset)
          ? this.nextCursor
          : nextCursor as String?,
      hasMore: hasMore ?? this.hasMore,
      totalCount: totalCount ?? this.totalCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      filtersData: identical(filtersData, _unset)
          ? this.filtersData
          : filtersData as SearchFiltersData?,
      selectedFilters: selectedFilters ?? this.selectedFilters,
      selectedAddress: identical(selectedAddress, _unset)
          ? this.selectedAddress
          : selectedAddress as Address?,
      selectedDateRange: identical(selectedDateRange, _unset)
          ? this.selectedDateRange
          : selectedDateRange as DateTimeRange?,
      guests: identical(guests, _unset) ? this.guests : guests as int?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

const _unset = Object();
