import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/data/enums/home_feed_scope.dart';
import 'package:immoplus/app/data/models/remote/search_filters/scope_search_response.dart';
import 'package:immoplus/app/data/models/remote/search_filters/search_filters_response.dart';
import 'package:immoplus/app/data/repositories/home_feed_repository.dart';
import 'package:immoplus/app/features/for_you/logic/scope_feed_state.dart';
import 'package:immoplus/app/features/location_module/data/model/address.dart';
import 'package:injectable/injectable.dart';

/// Cubit unifié pour les onglets « Trouver un logement », « Acheter un bien »,
/// « Trouver un séjour ».
///
/// Les résultats sont paginés par curseur selon le contrat du feed.
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

  /// Charge les filtres propres à l'onglet, puis son premier lot de résultats.
  Future<void> fetch() async {
    emit(state.copyWith(
      status: ScopeFeedStatus.loading,
      items: [],
      nextCursor: null,
      hasMore: false,
      totalCount: 0,
    ));
    try {
      SearchFiltersData? filtersData = state.filtersData;
      try {
        filtersData = await _repository.getSearchFilters(
          scope: state.scope.value,
        );
      } catch (error) {
        // Les résultats restent utilisables si la configuration publique des
        // filtres est momentanément indisponible.
        log('ScopeFeedCubit (${state.scope.value}): filtres indisponibles: $error');
      }

      final response = await _repository.searchScope(
        scope: state.scope,
        limit: 20,
        selectedFilters: state.selectedFilters,
        lat: state.selectedAddress?.latitude,
        lng: state.selectedAddress?.longitude,
        checkIn:
            state.isStay ? _formatDate(state.selectedDateRange?.start) : null,
        checkOut:
            state.isStay ? _formatDate(state.selectedDateRange?.end) : null,
        guests: state.guests,
      );

      emit(state.copyWith(
        status: ScopeFeedStatus.success,
        items: response.data,
        nextCursor: response.nextCursor,
        hasMore: response.hasMore,
        totalCount: response.totalCount,
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

  /// ONG.MD §4 — Recherche filtrée :
  /// Au clic sur « Chercher » ou au changement de filtre, ré-appeler l'endpoint
  /// avec les paramètres choisis. Réinitialise le curseur.
  Future<void> search() async {
    emit(state.copyWith(
      status: ScopeFeedStatus.loading,
      items: [],
      nextCursor: null,
      hasMore: false,
      totalCount: 0,
    ));
    try {
      final response = await _repository.searchScope(
        scope: state.scope,
        limit: 20,
        selectedFilters: state.selectedFilters,
        lat: state.selectedAddress?.latitude,
        lng: state.selectedAddress?.longitude,
        checkIn:
            state.isStay ? _formatDate(state.selectedDateRange?.start) : null,
        checkOut:
            state.isStay ? _formatDate(state.selectedDateRange?.end) : null,
        guests: state.guests,
      );

      emit(state.copyWith(
        status: ScopeFeedStatus.success,
        items: response.data,
        nextCursor: response.nextCursor,
        hasMore: response.hasMore,
        totalCount: response.totalCount,
      ));
    } catch (e) {
      log('ScopeFeedCubit (${state.scope.value}): Error searching: $e');
      emit(state.copyWith(
        status: ScopeFeedStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Charge la page suivante lorsque le curseur est disponible.
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.nextCursor == null)
      return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      final response = await _repository.searchScope(
        scope: state.scope,
        cursor: state.nextCursor,
        limit: 20,
        selectedFilters: state.selectedFilters,
        lat: state.selectedAddress?.latitude,
        lng: state.selectedAddress?.longitude,
        checkIn:
            state.isStay ? _formatDate(state.selectedDateRange?.start) : null,
        checkOut:
            state.isStay ? _formatDate(state.selectedDateRange?.end) : null,
        guests: state.guests,
      );

      emit(state.copyWith(
        items: _mergeById(state.items, response.data),
        nextCursor: response.nextCursor,
        hasMore: response.hasMore,
        totalCount: response.totalCount,
        isLoadingMore: false,
      ));
    } catch (e) {
      log('ScopeFeedCubit (${state.scope.value}): Error loading more: $e');
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  List<ScopeSearchItem> _mergeById(
    List<ScopeSearchItem> existing,
    List<ScopeSearchItem> incoming,
  ) {
    final byId = <String, ScopeSearchItem>{
      for (final item in existing) item.bienId: item,
    };
    for (final item in incoming) {
      if (item.bienId.isNotEmpty) byId[item.bienId] = item;
    }
    return byId.values.toList(growable: false);
  }

  /// ONG.MD §3 — Sélection d'un filtre :
  /// Extraire l'objet `params` de l'option choisie. Ce params sera fusionné
  /// automatiquement dans la requête au prochain appel `search()` ou `fetch()`.
  void setFilter(String filterKey, SearchFilterOption? option) {
    final updated =
        Map<String, SearchFilterOption?>.from(state.selectedFilters);
    if (option == null) {
      updated.remove(filterKey);
    } else {
      updated[filterKey] = option;
    }
    emit(state.copyWith(selectedFilters: updated));
  }

  void setAddress(Address? address) {
    emit(state.copyWith(selectedAddress: address));
  }

  void setDateRange(DateTimeRange? range) {
    emit(state.copyWith(selectedDateRange: range));
  }

  void setGuests(int? guests) {
    emit(state.copyWith(guests: guests));
  }

  /// Format `YYYY-MM-DD` attendu par le backend pour check_in / check_out.
  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
