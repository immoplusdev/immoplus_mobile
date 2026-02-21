import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_response.dart';
import 'package:immoplus/app/data/models/remote/furniture/furniture_model.dart';
import 'package:immoplus/app/data/repositories/furniture_repository.dart';
import 'package:injectable/injectable.dart';

import 'furniture_state.dart';

@injectable
class FurnitureCubit extends Cubit<FurnitureState> {
  final FurnitureRepository furnitureRepository;
  FurnitureCubit(this.furnitureRepository) : super(const FURNITURE_INITIAL());

  getFurniture({required String id}) async {
    emit(const FURNITURE_LOADING());
    try {
      FurnitureResponse furnitureResponse =
          await furnitureRepository.getFurniture(id);

      emit(FurnitureState.data(
          data: furnitureResponse.data ?? FurnitureModel()));
    } on DioException catch (dioError) {
      final error = dioError.response?.data;
      emit(FurnitureState.error(error: error['message'] ?? ""));
    } catch (e) {
      emit(FurnitureState.error(error: e.toString()));
    }
  }
}
