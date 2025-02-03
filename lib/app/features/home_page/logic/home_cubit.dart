import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/features/home_page/logic/home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(HomePageState(indexPage: 0));

  changeIndex(int index) {
    emit(HomePageState(indexPage: index));
  }
}
