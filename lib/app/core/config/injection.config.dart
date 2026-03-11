// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:immoplus/app/appli/utils/navigation_handler.dart' as _i983;
import 'package:immoplus/app/core/config/isar_config.dart' as _i847;
import 'package:immoplus/app/core/network/dio_config.dart' as _i947;
import 'package:immoplus/app/core/network/interceptors/auth_interceptor.dart'
    as _i180;
import 'package:immoplus/app/core/network/interceptors/error_interceptor.dart'
    as _i1023;
import 'package:immoplus/app/core/network/interceptors/request_interceptor.dart'
    as _i358;
import 'package:immoplus/app/core/network/utils/easy_loading_handler.dart'
    as _i415;
import 'package:immoplus/app/core/network/utils/env_handler.dart' as _i242;
import 'package:immoplus/app/core/network/utils/session_manager.dart' as _i22;
import 'package:immoplus/app/core/services/auth_redirect_service.dart' as _i944;
import 'package:immoplus/app/core/services/client_reservation_overlay_service.dart'
    as _i99;
import 'package:immoplus/app/core/services/notification_service.dart' as _i640;
import 'package:immoplus/app/core/services/remote_config_service.dart' as _i57;
import 'package:immoplus/app/data/repositories/bien_immobilier_repository.dart'
    as _i398;
import 'package:immoplus/app/data/repositories/furniture_repository.dart'
    as _i976;
import 'package:immoplus/app/data/repositories/residence_repository.dart'
    as _i143;
import 'package:immoplus/app/features/booking/logic/booking_cubit.dart'
    as _i237;
import 'package:immoplus/app/features/booking/logic/booking_services.dart'
    as _i946;
import 'package:immoplus/app/features/booking/pending_payment/pending_payment_reservations_cubit.dart'
    as _i527;
import 'package:immoplus/app/features/estate_detail/cubit/estate_cubit.dart'
    as _i488;
import 'package:immoplus/app/features/filter/logic/filter_cubit.dart' as _i79;
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart'
    as _i374;
import 'package:immoplus/app/features/furniture_detail/cubit/furniture_cubit.dart'
    as _i123;
import 'package:immoplus/app/features/home_page/logic/home_cubit.dart' as _i368;
import 'package:immoplus/app/features/home_page/logic/location_permission_cubit.dart'
    as _i529;
import 'package:immoplus/app/features/map_view/logics/map_viwer.cubit.dart'
    as _i1028;
import 'package:immoplus/app/features/notification/cubit/notification_cubit.dart'
    as _i430;
import 'package:immoplus/app/features/payment_module/bloc/payment_cubit.dart'
    as _i872;
import 'package:immoplus/app/features/residence_detail/cubit/residence_cubit.dart'
    as _i85;
import 'package:immoplus/app/features/visits/logic/visit_cubit.dart' as _i745;
import 'package:immoplus/app/logic/authentification/delete_account_cubit.dart'
    as _i636;
import 'package:immoplus/app/logic/authentification/login_cubit.dart' as _i888;
import 'package:immoplus/app/logic/authentification/registration_cubit.dart'
    as _i783;
import 'package:immoplus/app/logic/bloc/navigation_cubit.dart' as _i1001;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dioConfig = _$DioConfig();
    gh.factory<_i529.LocationPermissionCubit>(
        () => _i529.LocationPermissionCubit());
    gh.factory<_i368.HomePageCubit>(() => _i368.HomePageCubit());
    gh.factory<_i430.NotificationCubit>(() => _i430.NotificationCubit());
    gh.factory<_i872.PaymentCubit>(() => _i872.PaymentCubit());
    gh.factory<_i79.FilterCubit>(() => _i79.FilterCubit());
    gh.factory<_i1001.NavigationCubit>(() => _i1001.NavigationCubit());
    gh.factory<_i636.DeleteAccountCubit>(() => _i636.DeleteAccountCubit());
    gh.singleton<_i847.IsarConfig>(() => _i847.IsarConfig());
    gh.lazySingleton<_i358.RequestInterceptor>(
        () => _i358.RequestInterceptor());
    gh.lazySingleton<_i415.EasyLoadingHandler>(
        () => _i415.EasyLoadingHandler());
    gh.lazySingleton<_i242.EnvHandler>(() => _i242.EnvHandler());
    gh.lazySingleton<_i57.RemoteConfigService>(
        () => _i57.RemoteConfigService());
    gh.lazySingleton<_i944.AuthRedirectService>(
        () => _i944.AuthRedirectService());
    gh.singleton<_i22.SessionManager>(
        () => _i22.SessionManager(gh<_i847.IsarConfig>()));
    gh.singleton<_i374.FavoriesUtils>(
        () => _i374.FavoriesUtils(gh<_i847.IsarConfig>()));
    gh.factory<_i180.AuthInterceptor>(
        () => _i180.AuthInterceptor(gh<_i22.SessionManager>()));
    gh.singleton<_i983.NavigationHandler>(
        () => _i983.NavigationHandler(gh<_i22.SessionManager>()));
    gh.lazySingleton<_i1023.ErrorInterceptor>(
        () => _i1023.ErrorInterceptor(gh<_i22.SessionManager>()));
    gh.lazySingleton<_i640.NotificationService>(
        () => _i640.NotificationService(gh<_i22.SessionManager>()));
    gh.lazySingleton<_i361.Dio>(() => dioConfig.dio(
          gh<_i180.AuthInterceptor>(),
          gh<_i1023.ErrorInterceptor>(),
          gh<_i358.RequestInterceptor>(),
        ));
    gh.factory<_i976.FurnitureRepository>(
        () => _i976.FurnitureRepository(gh<_i361.Dio>()));
    gh.factory<_i398.BienImmobilierRepository>(
        () => _i398.BienImmobilierRepository(gh<_i361.Dio>()));
    gh.factory<_i143.ResidenceRepository>(
        () => _i143.ResidenceRepository(gh<_i361.Dio>()));
    gh.factory<_i745.VisitCubit>(
        () => _i745.VisitCubit(gh<_i398.BienImmobilierRepository>()));
    gh.factory<_i488.EstateCubit>(
        () => _i488.EstateCubit(gh<_i398.BienImmobilierRepository>()));
    gh.factory<_i527.PendingPaymentReservationsCubit>(() =>
        _i527.PendingPaymentReservationsCubit(gh<_i143.ResidenceRepository>()));
    gh.factory<_i946.BookingServices>(
        () => _i946.BookingServices(gh<_i361.Dio>()));
    gh.factory<_i1028.MapViwerCubit>(() => _i1028.MapViwerCubit(
          gh<_i143.ResidenceRepository>(),
          gh<_i398.BienImmobilierRepository>(),
        ));
    gh.factory<_i123.FurnitureCubit>(
        () => _i123.FurnitureCubit(gh<_i976.FurnitureRepository>()));
    gh.lazySingleton<_i99.ClientReservationOverlayService>(
        () => _i99.ClientReservationOverlayService(
              gh<_i143.ResidenceRepository>(),
              gh<_i22.SessionManager>(),
            ));
    gh.factory<_i783.RgistrationCubitCubit>(() => _i783.RgistrationCubitCubit(
          gh<_i22.SessionManager>(),
          gh<_i361.Dio>(),
          gh<_i640.NotificationService>(),
          gh<_i944.AuthRedirectService>(),
        ));
    gh.factory<_i888.LoginCubit>(() => _i888.LoginCubit(
          gh<_i22.SessionManager>(),
          gh<_i361.Dio>(),
          gh<_i640.NotificationService>(),
          gh<_i944.AuthRedirectService>(),
        ));
    gh.factory<_i85.ResidenceCubit>(
        () => _i85.ResidenceCubit(gh<_i143.ResidenceRepository>()));
    gh.factory<_i237.BookingCubit>(() => _i237.BookingCubit(
          gh<_i946.BookingServices>(),
          gh<_i143.ResidenceRepository>(),
        ));
    return this;
  }
}

class _$DioConfig extends _i947.DioConfig {}
