import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/utils/filter_handler.dart';

class FilterCubit extends Cubit<FilterHandler> {
  FilterCubit() : super(FilterHandler());

  refresh(FilterHandler filter) {
    emit(filter);
  }
}
