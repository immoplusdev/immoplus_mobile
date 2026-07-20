import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:immoplus/app/data/repositories/rating_repository.dart';
import 'package:immoplus/app/data/models/remote/rating/rating_request.dart';

part 'rating_state.dart';
part 'rating_cubit.freezed.dart';

@injectable
class RatingCubit extends Cubit<RatingState> {
  final RatingRepository _repository;

  RatingCubit(this._repository) : super(const RatingState.initial());

  Future<void> submitRating(RatingRequest request) async {
    emit(const RatingState.loading());
    try {
      await _repository.createClientRating(request);
      emit(const RatingState.success());
    } catch (e) {
      emit(RatingState.error(e.toString()));
    }
  }
}
