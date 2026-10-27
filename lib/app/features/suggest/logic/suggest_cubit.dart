import 'package:immoplus/app/core/error/error_messages.dart';
import 'package:immoplus/app/core/error/error_context.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:immoplus/app/data/repositories/suggest_repository.dart';
import 'suggest_state.dart';

@injectable
class SuggestCubit extends Cubit<SuggestState> {
  final SuggestRepository _repository;
  SuggestCubit(this._repository) : super(const SuggestState.initial());

  Future<void> fetchSuggestions({
    required String query,
    int? limit,
    double? lat,
    double? lng,
  }) async {
    if (query.trim().length < 2) {
      emit(const SuggestState.initial());
      return;
    }
    emit(const SuggestState.loading());
    try {
      final res = await _repository.getSuggestions(
        query: query,
        limit: limit,
        lat: lat,
        lng: lng,
      );
      emit(SuggestState.success(res.suggestions));
    } catch (e) {
      emit(SuggestState.error(
          ErrorMessages.messageOf(e, ErrorContext.feedLoad)));
    }
  }

  Future<void> trackSuggestionClick({
    required String query,
    required String type,
    required String id,
  }) async {
    await _repository.trackClick(query: query, type: type, id: id);
  }
}
