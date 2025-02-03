import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/appli/home_page_wrapper.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/features/account/account_page.dart';
import 'package:immoplus/app/features/account/pages/change_password.dart';
import 'package:immoplus/app/features/account/pages/edit_account.dart';
import 'package:immoplus/app/features/booking/booking_detail_page.dart';
import 'package:immoplus/app/features/booking_history/booking_history_page.dart';
import 'package:immoplus/app/features/estate_detail/estate_page.dart';
import 'package:immoplus/app/features/for_me/favorite_page.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/login_page/login_page.dart';
import 'package:immoplus/app/features/map_view/map_viewer.dart';
import 'package:immoplus/app/features/onboarding/onboarding_new_page.dart';
import 'package:immoplus/app/features/paymebt_history/payment_history_page.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/features/registration/customer_registration.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/features/visit_history/visit_history_page.dart';
import 'package:immoplus/app/features/visits/visit_detail_page.dart';
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
    redirect: (context, state) => showOnboarding ? '/onboarding' : null,
    routes: [
      GoRoute(
        path: '/',
        name: SplashScreen.name,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: '/payment_history',
        name: PaymentHistoryPage.name,
        builder: (context, state) => const PaymentHistoryPage(),
      ),
      GoRoute(
        path: '/login_page',
        name: LoginPage.name,
        builder: (context, state) => const LoginPage(),
      ),

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
        path: '/onboarding',
        name: OnboardingNewPage.name,
        builder: (context, state) => const OnboardingNewPage(),
      ),
      GoRoute(
        path: '/booking-history',
        name: BookingHistoryPage.name,
        builder: (context, state) => const BookingHistoryPage(),
      ),
      GoRoute(
        path: '/visites-history',
        name: VisitHistoryPage.name,
        builder: (context, state) => const VisitHistoryPage(),
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
            builder: (context, state) => const HomePage(),
          ),

          GoRoute(
            path: '/for_me',
            name: FavoritePage.name,
            builder: (context, state) => const FavoritePage(),
            routes: const [],
          ),

          // GoRoute(
          //     path: '/history',
          //     name: HistoricalPage.name,
          //     builder: (context, state) => const HistoricalPage(),
          //     routes: const []),
          GoRoute(
            path: '/map',
            name: MapViewer.name,
            builder: (context, state) => const MapViewer(),
          ),
          GoRoute(
            path: '/account',
            name: AccountPage.name,
            builder: (context, state) => AccountPage(),
          ),

          // Ajoutez plus de routes ici si nécessaire
        ],
      ),

      GoRoute(
        path: '/residence_detail/:idProduct',
        name: ResidencePage.name,
        builder: (context, state) => ResidencePage(
          idProduct: state.pathParameters['idProduct'] ?? '',
        ),
      ),

      GoRoute(
        path: '/estate_detail/:idProduct',
        name: EstatePage.name,
        builder: (context, state) => EstatePage(
          idProduct: state.pathParameters['idProduct'] ?? '',
          // bienImmobilierModel: state.extra as BienImmobilierModel,
        ),
      ),
      GoRoute(
        path: '/payment/reservations/:idProduct',
        builder: (context, state) => Scaffold(
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
      GoRoute(
        path: '/payment/demandes-visites/:idProduct',
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
        path: '/registration',
        name: CustomerRegistration.name,
        builder: (BuildContext context, GoRouterState state) {
          return const CustomerRegistration();
        },
      ),
    ],
  );
}
