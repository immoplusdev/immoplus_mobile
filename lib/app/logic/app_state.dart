abstract class AppState {
  static int indexService = 0;
  static Map<int, int?> _categoryMap = {
    4: 4, //Achat de propritétés,
    3: 14, //services
    2: 2, //Location,
    1: 3, // meubles
    0: 16, //Tout
  };
  static bool isLoading = true;
  static int? getCurrentCategory() => _categoryMap[indexService];
}

class InitialState extends AppState {}

class ProgressState<T> extends AppState {
  T data;
  ProgressState({required this.data});
}

class PendingState<T> extends AppState {}

class CloseState<T> extends AppState {}

class SuccessState extends AppState {}

class EmptyState extends AppState {}

class ErrorState extends AppState {}

class FinishState<T> extends AppState {
  T data;
  FinishState({required this.data});
}

//state of request ended T is ServiceState
class DoneState<T> extends AppState {
  FinishState<T> finishData;
  DoneState({required this.finishData});

  // FinishState getResult<U>({required U data}) => FinishState<U>(data: data);
}

class VisiteSate {}

class HistoryStae extends AppState {}
