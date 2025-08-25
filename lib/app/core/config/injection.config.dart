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
import 'package:immoplus/app/core/services/notification_service.dart' as _i640;
import 'package:immoplus/app/features/booking/logic/booking_cubit.dart'
    as _i237;
import 'package:immoplus/app/features/booking/logic/booking_services.dart'
    as _i946;
import 'package:immoplus/app/features/for_me/logic/favories_utils.dart'
    as _i374;
import 'package:immoplus/app/logic/authentification/login_cubit.dart' as _i888;
import 'package:immoplus/app/logic/authentification/registration_cubit.dart'
    as _i783;
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
    gh.singleton<_i847.IsarConfig>(() => _i847.IsarConfig());
    gh.lazySingleton<_i358.RequestInterceptor>(
        () => _i358.RequestInterceptor());
    gh.lazySingleton<_i415.EasyLoadingHandler>(
        () => _i415.EasyLoadingHandler());
    gh.lazySingleton<_i242.EnvHandler>(() => _i242.EnvHandler());
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
    gh.factory<_i946.BookingServices>(
        () => _i946.BookingServices(gh<_i361.Dio>()));
    gh.factory<_i783.RgistrationCubitCubit>(() => _i783.RgistrationCubitCubit(
          gh<_i22.SessionManager>(),
          gh<_i361.Dio>(),
          gh<_i640.NotificationService>(),
        ));
    gh.factory<_i888.LoginCubit>(() => _i888.LoginCubit(
          gh<_i22.SessionManager>(),
          gh<_i361.Dio>(),
          gh<_i640.NotificationService>(),
        ));
    gh.factory<_i237.BookingCubit>(
        () => _i237.BookingCubit(gh<_i946.BookingServices>()));
    return this;
  }
}

class _$DioConfig extends _i947.DioConfig {}
