import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/appli/home_page_wrapper.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/type/auth_redirect_data.dart';
import 'package:immoplus/app/features/account/account_page.dart';
import 'package:immoplus/app/features/account/pages/change_password.dart';
import 'package:immoplus/app/features/account/pages/edit_account.dart';
import 'package:immoplus/app/features/account/pages/permission_page.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/features/booking/booking_detail_page.dart';
import 'package:immoplus/app/features/booking_history/booking_history_page.dart';
import 'package:immoplus/app/features/estate_detail/estate_page.dart';
import 'package:immoplus/app/features/estate_detail/estate_user_page.dart';
import 'package:immoplus/app/features/for_me/favorite_page.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/home_page/screens/near_residences_page.dart';
import 'package:immoplus/app/features/home_page/screens/best_rated_residences_page.dart';
import 'package:immoplus/app/features/login_page/login_page.dart';
import 'package:immoplus/app/features/map_view/map_viewer.dart';
import 'package:immoplus/app/features/notification/pages/notification_page.dart';
import 'package:immoplus/app/features/onboarding/onboarding_new_page.dart';
import 'package:immoplus/app/features/otp_login/pages/otp_page_test.dart';
import 'package:immoplus/app/features/paymebt_history/payment_history_page.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/paiement_status_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/features/registration/customer_registration.dart';
import 'package:immoplus/app/features/registration/register_page.dart';
import 'package:immoplus/app/features/registration/screens/send_email_opt_page.dart';
import 'package:immoplus/app/features/registration/screens/verify_email_otp_page.dart';
import 'package:immoplus/app/features/reset_password/pages/reset_password_page.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/features/furniture_detail/furniture_detail_page.dart';
import 'package:immoplus/app/features/residence_detail/residences_user_page.dart';
import 'package:immoplus/app/features/vivre/vivre_page.dart';
import 'package:immoplus/app/features/visit_history/visit_history_page.dart';
import 'package:immoplus/app/features/visits/visit_detail_page.dart';
import 'package:immoplus/app/force_update_required_page.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit.dart';
import 'package:immoplus/app/screens/splash_screen.dart';
import 'package:immoplus/app/services/navigation_service.dart';

class AppRouter {
  static bool userIs = false;
  static bool alreadyOpened = false;
  static bool showOnboarding = false;
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static GoRouter router = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      print('🔍 GoRouter redirect - Location: ${state.uri}'); // ← DEBUG
      print('🔍 GoRouter redirect - Path: ${state.uri.path}');
      print('🔍 GoRouter redirect - Params: ${state.uri.queryParameters}');

      if (showOnboarding) return '/onboarding';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: SplashScreen.name,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: PaymentHistoryPage.routePath(),
        name: PaymentHistoryPage.name,
        builder: (context, state) => const PaymentHistoryPage(),
      ),
      // ShellRoute auth — sans navigatorKey, sans UI wrapper
      ShellRoute(
        builder: (context, state, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<LoginCubit>()),
              BlocProvider(create: (_) => getIt<RgistrationCubitCubit>()),
            ],
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/${AuthenticationPage.name}',
            name: AuthenticationPage.name,
            builder: (context, state) => AuthenticationPage(
              redirectData: state.extra as AuthRedirectData?,
            ),
          ),
          GoRoute(
            path: LoginPage.routePath(),
            name: LoginPage.name,
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: '/${RegisterPage.name}',
            name: RegisterPage.name,
            builder: (context, state) => const RegisterPage(),
          ),
          GoRoute(
            path: SendEmailOptPage.routePath(),
            name: SendEmailOptPage.name,
            builder: (context, state) => const SendEmailOptPage(),
          ),
          GoRoute(
            path: VerifyEmailOtpPage.routePath(),
            name: VerifyEmailOtpPage.name,
            builder: (context, state) => VerifyEmailOtpPage(
              email: state.extra as String,
            ),
          ),
          GoRoute(
            path: CustomerRegistration.routePath(),
            name: CustomerRegistration.name,
            builder: (context, state) => CustomerRegistration(
              data: state.extra as DataRouterRegistration,
            ),
          ),
        ],
      ),
      // GoRoute(
      //   path: '/login_page',
      //   name: LoginPage.name,
      //   builder: (context, state) => LoginPage(
      //     redirectData: state.extra as AuthRedirectData?,
      //   ),
      // ),
      // GoRoute(
      //   path: '/${RegisterPage.name}',
      //   name: RegisterPage.name,
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const RegisterPage();
      //   },
      // ),
      // GoRoute(
      //   path: '/${AuthenticationPage.name}',
      //   name: AuthenticationPage.name,
      //   builder: (context, state) => AuthenticationPage(
      //     redirectData: state.extra as AuthRedirectData?,
      //   ),
      // ),
      // GoRoute(
      //   path: '/send-email-otp',
      //   name: SendEmailOptPage.name,
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const SendEmailOptPage();
      //   },
      // ),
      // GoRoute(
      //   path: '/verify-email-otp',
      //   name: VerifyEmailOtpPage.name,
      //   builder: (BuildContext context, GoRouterState state) {
      //     return VerifyEmailOtpPage(email: state.extra as String);
      //   },
      // ),
      // GoRoute(
      //   path: '/registration',
      //   name: CustomerRegistration.name,
      //   builder: (BuildContext context, GoRouterState state) {
      //     return CustomerRegistration(
      //       data: state.extra as DataRouterRegistration,
      //     );
      //   },
      // ),

      GoRoute(
        path: '/edit_account',
        name: EditAccountPage.name,
        builder: (context, state) => const EditAccountPage(),
      ),
      GoRoute(
        path: '/change_password',
        name: ChangePassword.name,
        builder: (context, state) => const ChangePassword(),
      ),
      GoRoute(
        path: '/operetors_selector',
        name: OperatorsSelectorPage.name,
        builder: (context, state) => OperatorsSelectorPage(
          paymentPageAdapter: state.extra as PaymentPageAdapter,
        ),
      ),
      GoRoute(
        path: '/${PaiementStatusPage.name}',
        name: PaiementStatusPage.name,
        builder: (context, state) => PaiementStatusPage(
          paymentPageAdapter: state.extra as PaymentPageAdapter,
        ),
      ),
      GoRoute(
        path: '/onboarding',
        name: OnboardingNewPage.name,
        builder: (context, state) => const OnboardingNewPage(),
      ),
      GoRoute(
        path: BookingHistoryPage.routePath(),
        name: BookingHistoryPage.name,
        builder: (context, state) => BookingHistoryPage(
          reservationId: state.uri.queryParameters['reservationId'],
        ),
      ),
      GoRoute(
        path: ForceUpdateRequiredPage.routePath(),
        name: ForceUpdateRequiredPage.name,
        builder: (context, state) {
          final onUpdateTap = state.extra as Function()?;
          return ForceUpdateRequiredPage(
            onUpdateTap: onUpdateTap,
          );
        },
      ),
      GoRoute(
        path: VisitHistoryPage.routePath(),
        name: VisitHistoryPage.name,
        builder: (context, state) => const VisitHistoryPage(),
      ),
      GoRoute(
        path: '/otp-confirm',
        name: OtpPageTest.name,
        builder: (context, state) => OtpPageTest(
          currentPhoneNumber: state.extra as String,
        ),
      ),
      ShellRoute(
        navigatorKey: _rootNavigatorKey,
        builder: (context, state, child) {
          return HomePageWrapper(child: child);
        },
        routes: [
          GoRoute(
            path: '/homePage',
            name: HomePage.name,
            pageBuilder: (context, state) => NoTransitionPage(
              child: const HomePage(),
            ),
          ),
          GoRoute(
            path: '/for_me',
            name: FavoritePage.name,
            pageBuilder: (context, state) => NoTransitionPage(
              child: const FavoritePage(),
            ),
          ),
          GoRoute(
            path: '/vivre',
            name: VivrePage.name,
            pageBuilder: (context, state) => NoTransitionPage(
              child: const VivrePage(),
            ),
          ),
          GoRoute(
            path: '/map',
            name: MapViewer.name,
            pageBuilder: (context, state) => NoTransitionPage(
              child: const MapViewer(),
            ),
          ),
          GoRoute(
            path: '/account',
            name: AccountPage.name,
            pageBuilder: (context, state) => NoTransitionPage(
              child: AccountPage(),
            ),
          ),
        ],
      ),

      GoRoute(
        path: ResidencePage.routePath(),
        name: ResidencePage.name,
        builder: (context, state) => ResidencePage(
          idProduct: state.pathParameters['idProduct'] ?? '',
        ),
      ),

      GoRoute(
        path: NearResidencesPage.routePath,
        name: NearResidencesPage.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return NearResidencesPage(
            latitude: extra['lat'] as double,
            longitude: extra['long'] as double,
            radius: extra['radius'] as double? ?? 50,
          );
        },
      ),

      GoRoute(
        path: BestRatedResidencesPage.routePath,
        name: BestRatedResidencesPage.routeName,
        builder: (context, state) => const BestRatedResidencesPage(),
      ),

      GoRoute(
        path: FurnitureDetailPage.routePath(),
        name: FurnitureDetailPage.name,
        builder: (context, state) => FurnitureDetailPage(
          idProduct: state.pathParameters['idProduct'] ?? '',
        ),
      ),

      GoRoute(
        path: EstatePage.routePath(),
        name: EstatePage.name,
        builder: (context, state) => EstatePage(
          idProduct: state.pathParameters['idProduct'] ?? '',
        ),
      ),
      GoRoute(
        path: '/bien_detail/:bienId',
        redirect: (context, state) {
          final bienId = state.pathParameters['bienId'];
          return '/estate_detail/$bienId';
        },
      ),
      //TODO : vérifier que les routes depplink fonctionnent correctement
      GoRoute(
        path: '/user_residences/:userId',
        name: ResidencesUserPage.name,
        builder: (context, state) => ResidencesUserPage(
          userId: state.pathParameters['userId'] ?? '',
        ),
      ),

      GoRoute(
        path: '/user_estates/:userId',
        name: EstateUserPage.name,
        builder: (context, state) => EstateUserPage(
          proprietaireId: state.pathParameters['userId'] ?? '',
        ),
      ),

      GoRoute(
        path: '/payment/reservations/:idProduct',
        builder: (context, state) => WillPopScope(
          onWillPop: () async {
            context.goNamed(SplashScreen.name);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Réservation'),
              leading: IconButton(
                onPressed: () {
                  context.goNamed(SplashScreen.name);
                },
                icon: const Icon(FontAwesomeIcons.circleArrowLeft),
              ),
            ),
            body: BookingDetailPage(
              id: state.pathParameters['idProduct'] ?? '',
              // bienImmobilierModel: state.extra as BienImmobilierModel,
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/payment/demandes_visites/:idProduct',
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('Demande de visite'),
            leading: IconButton(
              onPressed: () {
                context.goNamed(SplashScreen.name);
              },
              icon: const Icon(FontAwesomeIcons.circleArrowLeft),
            ),
          ),
          body: VisitDetailPage(
            id: state.pathParameters['idProduct'] ?? '',
            // bienImmobilierModel: state.extra as BienImmobilierModel,
          ),
        ),
      ),

      GoRoute(
          path: '/order/:idProduct/:collection',
          builder: (BuildContext context, GoRouterState state) {
            String? type = state.pathParameters['type'];
            if (type == ServicesCollection.demandes_visites.name) {
              return VisitDetailPage(id: state.pathParameters['idProduct']!);
            } else if (type == ProductType.booking.name) {
              return BookingDetailPage(id: state.pathParameters['idProduct']!);
            } else if (type == ProductType.visit_to_ask.name) {
              return VisitDetailPage(id: state.pathParameters['idProduct']!);
            }
            return BookingDetailPage(
              id: state.pathParameters['idProduct']!,
            );
          }),
      // GoRoute(
      //     path: '/panier',
      //     builder: (BuildContext context, GoRouterState state) {
      //       return BasketPage();
      //     }),
      // GoRoute(
      //     path: '/cash',
      //     builder: (BuildContext context, GoRouterState state) {
      //       return CashFormularAction(
      //         orderCashModel: state.extra as OrderCashModel,
      //       );
      //     }),

      GoRoute(
        path: '/${NotificationsPage.name}',
        name: NotificationsPage.name,
        builder: (BuildContext context, GoRouterState state) {
          return const NotificationsPage();
        },
      ),
      GoRoute(
        path: '/${PermissionPage.name}',
        name: PermissionPage.name,
        builder: (BuildContext context, GoRouterState state) {
          return const PermissionPage();
        },
      ),
      GoRoute(
        path: '/reset-password',
        name: ResetPasswordPage.name,
        builder: (BuildContext context, GoRouterState state) {
          return const ResetPasswordPage();
        },
      ),
    ],
  );
}
