import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/data/repositories/home_feed_repository.dart';
import 'package:immoplus/app/features/for_you/logic/for_you_state.dart';
import 'package:injectable/injectable.dart';

/// Singleton (et non `@injectable`) : la même instance doit être partagée
/// entre le `BlocProvider` global ([list_bloc.dart]) et les appels statiques
/// de rafraîchissement (`HomePageState.refreshPage`) qui n'ont pas de
/// `BuildContext` pour faire `context.read<ForYouCubit>()`.
@lazySingleton
class ForYouCubit extends Cubit<ForYouState> {
  final HomeFeedRepository _repository;

  ForYouCubit(this._repository) : super(const ForYouState.initial());

  Future<void> fetch() async {
    emit(const ForYouState.loading());
    try {
      final data = await _repository.getHomeFeed();
      emit(ForYouState.success(
        sections: data.sections,
        hasMore: data.hasMore,
        nextCursor: data.nextCursor,
      ));
    } catch (e) {
      log('ForYouCubit: Error fetching home feed: $e');
      emit(ForYouState.error(message: e.toString()));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! ForYouSuccess) return;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));
    try {
      final data = await _repository.getHomeFeed(cursor: current.nextCursor);
      emit(current.copyWith(
        sections: [...current.sections, ...data.sections],
        hasMore: data.hasMore,
        nextCursor: data.nextCursor,
        isLoadingMore: false,
      ));
    } catch (e) {
      log('ForYouCubit: Error loading more sections: $e');
      emit(current.copyWith(isLoadingMore: false));
    }
  }
}
