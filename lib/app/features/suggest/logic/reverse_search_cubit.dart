import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/reverse_search_socket_service.dart';
import 'package:immoplus/app/data/models/remote/reverse_search/reverse_search_model.dart';
import 'package:immoplus/app/data/repositories/reverse_search_repository.dart';
import 'package:immoplus/app/features/suggest/logic/reverse_search_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReverseSearchCubit extends Cubit<ReverseSearchState> {
  final ReverseSearchRepository _repository;
  final ReverseSearchSocketService _socketService;
  final SessionManager _sessionManager;
  StreamSubscription? _propositionSub;
  StreamSubscription? _statusSub;

  ReverseSearchCubit(
      this._repository, this._socketService, this._sessionManager)
      : super(const ReverseSearchState.initial());

  Future<void> initiateSearch(ReverseSearchRequest request) async {
    emit(const ReverseSearchState.loading());
    try {
      final searchId = await _repository.createSearch(request);

      // Emit early to trigger navigation to the Map Page immediately
      emit(ReverseSearchState.searching(
        searchId: searchId,
        propositions: [],
        classicResidences: [],
      ));
    } catch (e) {
      String msg = e.toString().replaceAll('Exception: ', '');
      // TODO : TO DEBUG
      // emit(ReverseSearchState.searching(
      //   searchId: "searchId",
      //   propositions: [],
      //   classicResidences: [],
      // ));
      emit(ReverseSearchState.error(msg));
    }
  }

  void resumeSearch(String searchId, ReverseSearchRequest request,
      {List<ReverseSearchProposition>? propositions}) {
    final initialProps = (propositions != null && propositions.isNotEmpty)
        ? propositions
        : _socketService.getPropositions(searchId);
    emit(ReverseSearchState.searching(
      searchId: searchId,
      propositions: initialProps,
      classicResidences: [],
    ));
  }

  Future<void> startListening(
      String searchId, ReverseSearchRequest request) async {
    // Connect the socket
    final token = _sessionManager.currentUser?.accessToken;
    if (!_socketService.isConnected) {
      _socketService.connect(token);
    }

    // Récupérer les propositions de l'API GET /reverse-searches/:id si elles ne sont pas déjà chargées
    final bool hasPropsAlready = state.maybeWhen(
      searching: (id, currentProps, _) => currentProps.isNotEmpty,
      orElse: () => false,
    );

    if (!hasPropsAlready) {
      try {
        final detailedSearch = await _repository.getReverseSearchById(searchId);
        if (detailedSearch != null &&
            detailedSearch.propositionsList.isNotEmpty) {
          final apiProps = detailedSearch.propositionsList;
          state.maybeWhen(
            searching: (id, currentProps, classicProps) {
              if (currentProps.isEmpty) {
                emit(ReverseSearchState.searching(
                  searchId: searchId,
                  propositions: apiProps,
                  classicResidences: classicProps,
                ));
              }
            },
            orElse: () {},
          );
        }
      } catch (e) {
        debugPrint('Error fetching reverse search by id: $e');
      }
    }

    _propositionSub?.cancel();
    _propositionSub = _socketService.onProposition.listen((propositions) {
      if (propositions.isEmpty ||
          propositions.first.reverseSearchId != searchId) {
        return;
      }
      state.maybeWhen(
        searching: (id, props, classicProps) {
          // Le backend renvoie la liste complète des résidences disponibles :
          // on remplace, on n'ajoute pas.
          emit(ReverseSearchState.searching(
              searchId: searchId,
              propositions: propositions,
              classicResidences: classicProps));
        },
        orElse: () {},
      );
    });

    _statusSub?.cancel();
    _statusSub = _socketService.onStatus.listen((status) {
      if (status == 'selection_expiree') {
        // Revenir à l'état de recherche si la sélection expire
        state.maybeWhen(
          locked: (id, prop) {
            emit(ReverseSearchState.searching(
                searchId: id, propositions: [prop], classicResidences: []));
          },
          orElse: () {},
        );
      } else if (status == 'annulee') {
        emit(const ReverseSearchState.initial());
      }
    });

    // Fetch classic residences in the background
    try {
      final classicRes = await _repository.getClassicResidences(request);
      state.maybeWhen(
        searching: (id, props, _) {
          emit(ReverseSearchState.searching(
            searchId: searchId,
            propositions: props.isNotEmpty
                ? props
                : _socketService.getPropositions(searchId),
            classicResidences: classicRes.data ?? [],
          ));
        },
        orElse: () {},
      );
    } catch (e) {
      debugPrint('Error fetching classic residences: $e');
    }
  }

  Future<void> lockResidence(
      String searchId, ReverseSearchProposition proposition) async {
    final prevState = state;
    emit(const ReverseSearchState.loading());
    try {
      await _repository.selectResidence(searchId, proposition.data.id);
      emit(ReverseSearchState.locked(
          searchId: searchId, proposition: proposition));
    } catch (e) {
      String msg = e.toString().replaceAll('Exception: ', '');
      emit(ReverseSearchState.error(msg));
      emit(prevState); // Revenir à l'état précédent (searching)
    }
  }

  Future<void> cancelSearch(String searchId) async {
    try {
      await _repository.cancelSearch(searchId);
      emit(const ReverseSearchState.initial());
      _socketService.disconnect(searchId: searchId);
    } catch (e) {
      String msg = e.toString().replaceAll('Exception: ', '');
      emit(ReverseSearchState.error(msg));
    }
  }

  Future<bool> cancelActiveSearch() async {
    emit(const ReverseSearchState.loading());
    try {
      final bool cancelled = await _repository.cancelActiveSearch();
      emit(const ReverseSearchState.initial());
      _socketService.disconnect();
      return cancelled;
    } catch (e) {
      String msg = e.toString().replaceAll('Exception: ', '');
      emit(ReverseSearchState.error(msg));
      return false;
    }
  }

  @override
  Future<void> close() {
    _propositionSub?.cancel();
    _statusSub?.cancel();
    return super.close();
  }
}
