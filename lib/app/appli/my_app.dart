import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:immoplus/app/configs/theme_config.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/utils/list_bloc.dart';
import 'package:immoplus/supported_locales.dart';
import 'package:toastification/toastification.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  chekUser() async {}

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBlocs.listBlocProviders,
      child: ToastificationWrapper(
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: MaterialApp.router(
              localizationsDelegates: const [
                CountryLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate, // This is required
              ],
              supportedLocales: immoPlusSupportedLocales,
              debugShowCheckedModeBanner: false,
              theme: ThemeConfig.lightTheme(context: context),
              routeInformationParser: AppRouter.router.routeInformationParser,
              routeInformationProvider:
                  AppRouter.router.routeInformationProvider,
              routerDelegate: AppRouter.router.routerDelegate,
              backButtonDispatcher: AppRouter.router.backButtonDispatcher,
              builder: EasyLoading.init()
              //  (context, child) {
              //   child = EasyLoading.init()(
              //       context, child); // assuming this is returning a widget
              //   child = InAppNotifications.init()(context, child);
              //   return child;
              // },
              ),
        ),
      ),
    );
  }
}
