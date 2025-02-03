import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/features/booking/logic/booking_cubit.dart';
import 'package:immoplus/app/features/estate_detail/cubit/estate_cubit.dart';
import 'package:immoplus/app/features/home_page/logic/home_cubit.dart';
import 'package:immoplus/app/features/map_view/logics/map_viwer.cubit.dart';
import 'package:immoplus/app/features/payment_module/bloc/payment_cubit.dart';
import 'package:immoplus/app/features/residence_detail/cubit/residence_cubit.dart';
import 'package:immoplus/app/features/visits/logic/visit_cubit.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/logic/bloc/navigation_cubit.dart';

class AppBlocs {
  static List<BlocProvider> listBlocProviders = [
    BlocProvider<LoginCubit>(
      create: (context) => getIt<LoginCubit>(),
    ),
    // BlocProvider<GalleryCubit>(
    //   create: (context) => GalleryCubit(),
    // ),
    // BlocProvider<ProductCubit>(
    //   create: (context) => ProductCubit(),
    // ),
    BlocProvider<NavigationCubit>(
      create: (context) => NavigationCubit(),
    ),
    BlocProvider<HomePageCubit>(
      create: (context) => HomePageCubit(),
    ),
    BlocProvider<BookingCubit>(
      create: (context) => BookingCubit(),
    ),
    BlocProvider<VisitCubit>(
      create: (context) => VisitCubit(),
    ),
    BlocProvider<EstateCubit>(
      create: (context) => EstateCubit(),
    ),
    // BlocProvider<HistoryCubit>(
    //   create: (context) => HistoryCubit(),
    // ),
    BlocProvider<MapViwerCubit>(
      create: (context) => MapViwerCubit(),
    ),
    BlocProvider<ResidenceCubit>(
      create: (context) => ResidenceCubit(),
    ),
    BlocProvider<PaymentCubit>(
      create: (context) => PaymentCubit(),
    ),
    // BlocProvider<MapViewerCubit>(
    //   create: (context) => MapViewerCubit(),
    // ),
  ];
}
