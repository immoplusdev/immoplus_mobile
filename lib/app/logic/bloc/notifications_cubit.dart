// part of cubits;

// import 'package:flutter_bloc/flutter_bloc.dart';

// class NotificationsState {
//   static int numberOfNotifs = 0;
// }

// class NotificationCubit extends Cubit<AppState> {
//   NotificationCubit() : super(InitialState());

//   static int indexController = 0;
//   onGetData({required BuildContext context, bool update = false}) async {
//     try {
//       emit(PendingState());

//       List<NotificationModel> notification =
//           await Repository<NotificationModel>(NotificationModel())
//               .fetchListData(
//                   requestInfo: RequestInfo(
//                     method: METHOD.GET,
//                     path: RequestPath.notifications,
//                   ),
//                   context: context) as List<NotificationModel>;
//       int _save = await LocalStorage().getNumberOfNotificaiton();
//       NotificationsState.numberOfNotifs =
//           (notification.length > _save) ? notification.length - _save : 0;
//       if (update) {
//         LocalStorage().setNumberOfNotificaiton(numb: notification.length);
//       }
//       emit(FinishState<List<NotificationModel>>(data: notification));
//     } catch (e) {
//       log(e.toString(), name: "ERROR");
//       emit(InitialState());
//     }
//   }
// }
