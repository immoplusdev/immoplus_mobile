import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';

part 'furniture_state.freezed.dart';

@freezed
class FurnitureState with _$FurnitureState {
  const factory FurnitureState.initial() = FURNITURE_INITIAL;
  const factory FurnitureState.loading() = FURNITURE_LOADING;
  const factory FurnitureState.data({required FurnitureModel data}) =
      FURNITURE_DATA;
  const factory FurnitureState.error({required String error}) = FURNITURE_ERROR;
}
