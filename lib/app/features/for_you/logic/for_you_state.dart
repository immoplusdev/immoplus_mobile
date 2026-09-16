import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_section.dart';

part 'for_you_state.freezed.dart';

@freezed
class ForYouState with _$ForYouState {
  const factory ForYouState.initial() = ForYouInitial;
  const factory ForYouState.loading() = ForYouLoading;
  const factory ForYouState.error({required String message}) = ForYouError;
  const factory ForYouState.success({
    required List<HomeFeedSection> sections,
    required bool hasMore,
    String? nextCursor,
    @Default(false) bool isLoadingMore,
  }) = ForYouSuccess;
}
