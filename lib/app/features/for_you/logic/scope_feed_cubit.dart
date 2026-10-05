import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/data/enums/home_feed_scope.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_response.dart';
import 'package:immoplus/app/data/models/remote/search_filters/search_filters_response.dart';
import 'package:immoplus/app/data/repositories/home_feed_repository.dart';
import 'package:immoplus/app/features/for_you/logic/scope_feed_state.dart';
import 'package:immoplus/app/features/location_module/data/model/address.dart';
import 'package:injectable/injectable.dart';

@injectable
class ScopeFeedCubit extends Cubit<ScopeFeedState> {
  final HomeFeedRepository _repository;

  ScopeFeedCubit(
    this._repository, {
    @factoryParam HomeFeedScope scope = HomeFeedScope.rent,
  }) : super(ScopeFeedState(scope: scope));

  void init(HomeFeedScope scope) {
    if (state.scope != scope || state.status == ScopeFeedStatus.initial) {
      emit(state.copyWith(scope: scope));
      fetch();
    }
  }

  Future<void> fetch() async {
    emit(state.copyWith(status: ScopeFeedStatus.loading));
    try {
      // 1. Chargement des filtres depuis /me/search/filters
      SearchFiltersData? filtersData = state.filtersData;
      try {
        filtersData = await _repository.getSearchFilters(scope: state.scope.value);
      } catch (e) {
        log('ScopeFeedCubit (${state.scope.value}): Error fetching search filters: $e');
      }

      // 2. Chargement du flux de sections adapté au scope
      final HomeFeedData feedData = await _fetchFeedData(scope: state.scope);

      emit(state.copyWith(
        status: ScopeFeedStatus.success,
        sections: feedData.sections,
        hasMore: feedData.hasMore,
        nextCursor: feedData.nextCursor,
        filtersData: filtersData,
      ));
    } catch (e) {
      log('ScopeFeedCubit (${state.scope.value}): Error fetching feed: $e');
      emit(state.copyWith(
        status: ScopeFeedStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      final feedData = await _fetchFeedData(
        scope: state.scope,
        cursor: state.nextCursor,
      );

      emit(state.copyWith(
        sections: [...state.sections, ...feedData.sections],
        hasMore: feedData.hasMore,
        nextCursor: feedData.nextCursor,
        isLoadingMore: false,
      ));
    } catch (e) {
      log('ScopeFeedCubit (${state.scope.value}): Error loading more sections: $e');
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<HomeFeedData> _fetchFeedData({
    required HomeFeedScope scope,
    String? cursor,
  }) async {
    switch (scope) {
      case HomeFeedScope.stay:
        return _repository.getStayFeed(cursor: cursor);
      case HomeFeedScope.buy:
        return _repository.getBuyFeed(cursor: cursor);
      case HomeFeedScope.rent:
        return _repository.getRentFeed(cursor: cursor);
    }
  }

  void setAddress(Address? address) {
    emit(state.copyWith(selectedAddress: address));
  }

  void setFilter(String filterKey, SearchFilterOption? option) {
    final updated = Map<String, SearchFilterOption?>.from(state.selectedFilters);
    if (option == null) {
      updated.remove(filterKey);
    } else {
      updated[filterKey] = option;
    }
    emit(state.copyWith(selectedFilters: updated));
  }

  void setDateRange(DateTimeRange? range) {
    emit(state.copyWith(selectedDateRange: range));
  }
}
