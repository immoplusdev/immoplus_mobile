import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:injectable/injectable.dart';

@injectable
class FilterCubit extends Cubit<FilterHandler> {
  FilterCubit() : super(FilterHandler());

  refresh(FilterHandler filter) {
    emit(filter);
  }
}
