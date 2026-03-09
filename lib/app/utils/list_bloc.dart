import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/features/booking/logic/booking_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/location_permission_cubit.dart';
import 'package:immoplus/app/features/estate_detail/cubit/estate_cubit.dart';
import 'package:immoplus/app/features/filter/logic/filter_cubit.dart';
import 'package:immoplus/app/features/furniture_detail/cubit/furniture_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/home_cubit.dart';
import 'package:immoplus/app/features/map_view/logics/map_viwer.cubit.dart';
import 'package:immoplus/app/features/notification/cubit/notification_cubit.dart';
import 'package:immoplus/app/features/payment_module/bloc/payment_cubit.dart';
import 'package:immoplus/app/features/residence_detail/cubit/residence_cubit.dart';
import 'package:immoplus/app/features/visits/logic/visit_cubit.dart';
import 'package:immoplus/app/logic/authentification/delete_account_cubit.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit.dart';
import 'package:immoplus/app/logic/bloc/navigation_cubit.dart';

class AppBlocs {
  static List<BlocProvider> listBlocProviders = [
    BlocProvider<LoginCubit>(
      create: (context) => getIt<LoginCubit>(),
    ),
    BlocProvider<RgistrationCubitCubit>(
      create: (context) => getIt<RgistrationCubitCubit>(),
    ),
    BlocProvider<NavigationCubit>(
      create: (context) => NavigationCubit(),
    ),

    BlocProvider<HomePageCubit>(
      create: (context) => HomePageCubit(),
    ),
    BlocProvider<LocationPermissionCubit>(
      create: (context) => getIt<LocationPermissionCubit>()..checkPermission(),
    ),
    BlocProvider<DeleteAccountCubit>(
      create: (context) => DeleteAccountCubit(),
    ),
    BlocProvider<BookingCubit>(
      create: (context) => getIt<BookingCubit>(),
    ),
    BlocProvider<VisitCubit>(
      create: (context) => getIt<VisitCubit>(),
    ),
    BlocProvider<EstateCubit>(
      create: (context) => getIt<EstateCubit>(),
    ),
    // BlocProvider<HistoryCubit>(
    //   create: (context) => HistoryCubit(),
    // ),
    BlocProvider<MapViwerCubit>(
      create: (context) => getIt<MapViwerCubit>(),
    ),
    BlocProvider<ResidenceCubit>(
      create: (context) => getIt<ResidenceCubit>(),
    ),
    BlocProvider<FurnitureCubit>(
      create: (context) => getIt<FurnitureCubit>(),
    ),
    BlocProvider<PaymentCubit>(
      create: (context) => getIt<PaymentCubit>(),
    ),
    BlocProvider<FilterCubit>(
      create: (context) => FilterCubit(),
    ),
    // BlocProvider<MapViewerCubit>(
    //   create: (context) => MapViewerCubit(),
    // ),
    BlocProvider<NotificationCubit>(
      create: (context) => NotificationCubit(),
    ),
  ];
}
