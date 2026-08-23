import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/reverse_search_socket_service.dart';
import 'package:immoplus/app/data/models/remote/residence/residence_model.dart';
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

  void resumeSearch(
    String searchId,
    ReverseSearchRequest request, {
    List<ReverseSearchProposition>? propositions,
    ReverseSearchProposition? pendingSelection,
    DateTime? selectionExpireAt,
  }) {
    debugPrint(
        '[ReverseSearch] cubit.resumeSearch: searchId=$searchId isClosed=$isClosed currentState=$state');
    final initialProps = (propositions != null && propositions.isNotEmpty)
        ? propositions
        : _socketService.getPropositions(searchId);
    // Ne jamais écraser "Sur demande" avec []: on préserve ce qui est déjà
    // chargé (via startListening) plutôt que de le vider à chaque resume —
    // sinon la section disparaît à chaque retour (paiement, résidence...).
    final currentClassicResidences = state.maybeWhen(
      searching: (_, __, classicResidences, ___, ____) => classicResidences,
      orElse: () => const <ResidenceModel>[],
    );
    emit(ReverseSearchState.searching(
      searchId: searchId,
      propositions: initialProps,
      classicResidences: currentClassicResidences,
      pendingSelection: pendingSelection,
      selectionExpireAt: selectionExpireAt,
    ));
    debugPrint('[ReverseSearch] cubit.resumeSearch: emitted, newState=$state');
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
      searching: (id, currentProps, _, __, ___) => currentProps.isNotEmpty,
      orElse: () => false,
    );

    if (!hasPropsAlready) {
      try {
        final detailedSearch = await _repository.getReverseSearchById(searchId);
        if (detailedSearch != null &&
            detailedSearch.propositionsList.isNotEmpty) {
          final apiProps = detailedSearch.propositionsList;
          state.maybeWhen(
            searching: (id, currentProps, classicProps, pending, expireAt) {
              if (currentProps.isEmpty) {
                emit(ReverseSearchState.searching(
                  searchId: searchId,
                  propositions: apiProps,
                  classicResidences: classicProps,
                  pendingSelection: pending,
                  selectionExpireAt: expireAt,
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
        searching: (id, props, classicProps, pending, expireAt) {
          // Le backend renvoie la liste complète des résidences disponibles :
          // on remplace, on n'ajoute pas.
          emit(ReverseSearchState.searching(
              searchId: searchId,
              propositions: propositions,
              classicResidences: classicProps,
              pendingSelection: pending,
              selectionExpireAt: expireAt));
        },
        orElse: () {},
      );
    });

    _statusSub?.cancel();
    _statusSub = _socketService.onStatus.listen((status) {
      if (status == 'selection_expiree') {
        clearPendingSelection();
      } else if (status == 'annulee') {
        emit(const ReverseSearchState.initial());
      }
    });

    // Fetch classic residences in the background
    try {
      final classicRes = await _repository.getClassicResidences(request);
      state.maybeWhen(
        searching: (id, props, _, pending, expireAt) {
          emit(ReverseSearchState.searching(
            searchId: searchId,
            propositions: props.isNotEmpty
                ? props
                : _socketService.getPropositions(searchId),
            classicResidences: classicRes.data ?? [],
            pendingSelection: pending,
            selectionExpireAt: expireAt,
          ));
        },
        orElse: () {},
      );
    } catch (e) {
      debugPrint('Error fetching classic residences: $e');
    }
  }

  /// Retire l'épinglage "en attente de paiement" de l'état courant, sans
  /// perdre les propositions déjà chargées. Appelé quand la sélection expire
  /// — via l'event socket serveur `selection_expiree`, ou directement côté
  /// client dès que le compte à rebours atteint zéro (pas besoin d'attendre
  /// le serveur : passé les 10 minutes, la sélection est de toute façon
  /// caduque).
  void clearPendingSelection() {
    state.maybeWhen(
      searching: (id, props, classicProps, pending, _) {
        if (pending != null) {
          emit(ReverseSearchState.searching(
            searchId: id,
            propositions: props,
            classicResidences: classicProps,
          ));
        }
      },
      orElse: () {},
    );
  }

  /// Sélectionne une résidence et l'épingle dans la liste en attente de
  /// paiement (état [ReverseSearchState.searching] avec [pendingSelection]).
  Future<void> lockResidence(
      String searchId, ReverseSearchProposition proposition) async {
    final prevState = state;
    try {
      await _repository.selectResidence(searchId, proposition.data.id);
      prevState.maybeWhen(
        searching: (id, props, classicProps, _, __) {
          emit(ReverseSearchState.searching(
            searchId: id,
            propositions: props,
            classicResidences: classicProps,
            pendingSelection: proposition,
          ));
        },
        orElse: () {},
      );
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
