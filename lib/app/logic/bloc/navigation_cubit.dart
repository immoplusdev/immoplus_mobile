import 'package:bloc/bloc.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:injectable/injectable.dart';

@injectable
class NavigationCubit extends Cubit<PageState> {
  NavigationCubit() : super(PageState.home);

  void switchPage(PageState page) {
    emit(page);
  }
}
