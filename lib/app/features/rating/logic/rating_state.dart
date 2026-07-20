part of 'rating_cubit.dart';

@freezed
class RatingState with _$RatingState {
  const factory RatingState.initial() = _Initial;
  const factory RatingState.loading() = _Loading;
  const factory RatingState.success() = _Success;
  const factory RatingState.error(String message) = _Error;
}
