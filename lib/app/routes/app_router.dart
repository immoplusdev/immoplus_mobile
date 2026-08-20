import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/appli/home_page_wrapper.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/type/auth_redirect_data.dart';
import 'package:immoplus/app/data/enums/home_tab.dart';
import 'package:immoplus/app/data/models/remote/hotel/hotel_detail_model.dart';
import 'package:immoplus/app/features/account/account_page.dart';
import 'package:immoplus/app/features/account/pages/change_credentials_page.dart';
import 'package:immoplus/app/features/notification/model/notification_model.dart';
import 'package:immoplus/app/features/settings/contact_change/cubit/contact_change_cubit.dart';
import 'package:immoplus/app/features/settings/contact_change/view/confirm_contact_change_page.dart';
import 'package:immoplus/app/features/settings/contact_change/view/request_contact_change_page.dart';
import 'package:immoplus/app/data/enums/contact_change_type.dart';
import 'package:immoplus/app/features/account/pages/change_password.dart';
import 'package:immoplus/app/features/account/pages/edit_account.dart';
import 'package:immoplus/app/features/account/pages/permission_page.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';
import 'package:immoplus/app/features/become_pro/pages/become_pro_intro_page.dart';
import 'package:immoplus/app/features/become_pro/pages/become_pro_form_page.dart';
import 'package:immoplus/app/features/booking/booking_detail_page.dart';
import 'package:immoplus/app/features/booking_history/booking_history_page.dart';
import 'package:immoplus/app/features/rating/pages/rating_history_page.dart';
import 'package:immoplus/app/features/estate_detail/estate_page.dart';
import 'package:immoplus/app/features/estate_detail/estate_user_page.dart';
import 'package:immoplus/app/features/fast-track-book/reservation_engagement.dart';
import 'package:immoplus/app/features/home_page/home_page.dart';
import 'package:immoplus/app/features/home_page/screens/near_residences_page.dart';
import 'package:immoplus/app/features/home_page/screens/location_residences_page.dart';
import 'package:immoplus/app/features/home_page/screens/location_biens_page.dart';
import 'package:immoplus/app/features/home_page/screens/location_furnitures_page.dart';
import 'package:immoplus/app/utils/filter_handler.dart';
import 'package:immoplus/app/features/my_choice/my_choice_page.dart';
import 'package:immoplus/app/features/home_page/screens/best_rated_residences_page.dart';
import 'package:immoplus/app/features/home_page/screens/reduction_residences_page.dart';
import 'package:immoplus/app/features/login_page/login_page.dart';
import 'package:immoplus/app/features/map_view/map_viewer.dart';
import 'package:immoplus/app/features/notification/pages/notification_page.dart';
import 'package:immoplus/app/features/notification/pages/notification_detail_page.dart';
import 'package:immoplus/app/features/user_preference/pages/user_preference_page.dart';
import 'package:immoplus/app/features/onboarding/onboarding_new_page.dart';
import 'package:immoplus/app/features/otp_login/pages/otp_page.dart';
import 'package:immoplus/app/features/paymebt_history/payment_history_page.dart';
import 'package:immoplus/app/features/payment_module/operators_selector_page.dart';
import 'package:immoplus/app/features/payment_module/paiement_status_page.dart';
import 'package:immoplus/app/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus/app/features/registration/customer_registration.dart';
import 'package:immoplus/app/features/registration/register_page.dart';
import 'package:immoplus/app/data/enums/registration_type.dart';
import 'package:immoplus/app/data/models/auth/verify_otp_extra.dart';
import 'package:immoplus/app/features/registration/screens/register_number_otp.dart';
import 'package:immoplus/app/features/registration/screens/send_email_or_number_opt_page.dart';
import 'package:immoplus/app/features/registration/screens/verify_email_otp_page.dart';
import 'package:immoplus/app/features/reset_password/pages/reset_password_page.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/features/furniture_detail/furniture_detail_page.dart';
import 'package:immoplus/app/features/residence_detail/residences_user_page.dart';
import 'package:immoplus/app/features/hotel/pages/hotel_search_page.dart';
import 'package:immoplus/app/features/hotel/pages/hotel_detail_page.dart';
import 'package:immoplus/app/features/hotel/pages/hotel_booking_selection_page.dart';
import 'package:immoplus/app/features/hotel/pages/hotel_booking_summary_page.dart';
import 'package:immoplus/app/features/hotel/pages/hotel_room_detail_page.dart';
import 'package:immoplus/app/features/hotel/pages/hotel_search_result_page.dart';
import 'package:immoplus/app/features/vivre/vivre_page.dart';
import 'package:immoplus/app/features/booking/pending_payment/pending_payment_reservations_page.dart';
import 'package:immoplus/app/features/visit_history/visit_history_page.dart';
import 'package:immoplus/app/features/visits/visit_detail_page.dart';
import 'package:immoplus/app/features/visits/visit_pending_page.dart';
import 'package:immoplus/app/force_update_required_page.dart';
import 'package:immoplus/app/logic/authentification/login_cubit.dart';
import 'package:immoplus/app/logic/authentification/registration_cubit.dart';
import 'package:immoplus/app/screens/splash_screen.dart';
import 'package:immoplus/app/logic/bloc/navigation_cubit.dart';
import 'package:immoplus/app/services/navigation_service.dart';
import 'package:immoplus/app/features/alert/pages/alert_list_page.dart';
import 'package:immoplus/app/features/alert/pages/alert_create_edit_page.dart';
import 'package:immoplus/app/features/alert/pages/alert_propositions_page.dart';
import 'package:immoplus/app/data/models/remote/alert/alert_model.dart';
import 'package:immoplus/app/features/alert/pages/alert_success_page.dart';
import 'package:immoplus/app/features/alert/pages/alert_detail_page.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/features/booking/widgets/kyc_webview_page.dart';
import 'package:immoplus/app/features/suggest/pages/search_container_page.dart';
import 'package:immoplus/app/features/suggest/pages/suggest_page.dart';
import 'package:immoplus/app/features/suggest/pages/search_result_page.dart';
import 'package:immoplus/app/features/payment_module/stripe_result_route.dart';
import 'package:immoplus/app/data/models/remote/payment/payment_itent_data.dart';
import 'package:immoplus/app/features/suggest/pages/reverse_search_map_page.dart';
import 'package:immoplus/app/features/suggest/logic/reverse_search_cubit.dart';
import 'package:immoplus/app/data/models/remote/reverse_search/reverse_search_model.dart';

class AppRouter {
  static bool userIs = false;
  static bool alreadyOpened = false;
  static bool showOnboarding = false;
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static GoRouter router = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    initialLocation: '/',
    observers: [
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ],
    redirect: (context, state) async {
      print('🔍 GoRouter redirect - Location: ${state.uri}'); // ← DEBUG
      print('🔍 GoRouter redirect - Path: ${state.uri.path}');
      print('🔍 GoRouter redirect - Params: ${state.uri.queryParameters}');

      if (showOnboarding) return '/onboarding';

      // Load user session if not already loaded (e.g. on direct deep-link launch)
      final sessionManager = getIt<SessionManager>();
      if (sessionManager.currentUser == null) {
        await sessionManager.getCurrentUser();
      }

      if (!context.mounted) return null;

      final path = state.uri.path;

      if (path == PendingPaymentReservationsPage.routePath()) {
        if (sessionManager.currentUser == null) {
          print(
              '🔒 User not authenticated, redirecting from pending-payment-reservations to homePage');
          return state.namedLocation(HomePage.name);
        }
      }

      // Synchronise l'onglet actif quand on arrive par deep link (sans passer par les tabs)
      if (path.startsWith('/vivre') || path.startsWith('/v/')) {
        context.read<NavigationCubit>().switchPage(PageState.vivre);
      } else if (path.startsWith('/homePage')) {
        context.read<NavigationCubit>().switchPage(PageState.home);
      } else if (path.startsWith('/for_me')) {
        context.read<NavigationCubit>().switchPage(PageState.forMe);
      } else if (path.startsWith('/map')) {
        context.read<NavigationCubit>().switchPage(PageState.explore);
      } else if (path.startsWith('/account')) {
        context.read<NavigationCubit>().switchPage(PageState.account);
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: SplashScreen.name,
        builder: (context, state) => const SplashScreen(),
      ),

      // TODO CLEAN
      GoRoute(
        path: '/payment/hotel_reservations/:idProduct',
        redirect: (context, state) {
          final sessionManager = getIt<SessionManager>();
          if (sessionManager.currentUser == null) {
            return state.namedLocation(HomePage.name);
          }
          return null;
        },
        builder: (context, state) => const PaymentHistoryPage(),
      ),
      // TODO CLEAN
      GoRoute(
        path: '/payment/hotel_reservation/:idProduct',
        redirect: (context, state) {
          final sessionManager = getIt<SessionManager>();
          if (sessionManager.currentUser == null) {
            return state.namedLocation(HomePage.name);
          }
          return null;
        },
        builder: (context, state) => const PaymentHistoryPage(),
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
            builder: (context, state) => RegisterPage(
              redirectData: state.extra as AuthRedirectData?,
            ),
          ),
          GoRoute(
            path: RegisterNumberOtpPage.routePath(),
            name: RegisterNumberOtpPage.name,
            builder: (context, state) => RegisterNumberOtpPage(
              redirectData: state.extra as AuthRedirectData?,
            ),
          ),
          GoRoute(
            path: SendEmailOrNumberOptPage.routePath(),
            name: SendEmailOrNumberOptPage.name,
            builder: (context, state) => SendEmailOrNumberOptPage(
              type: state.extra as RegistrationType? ?? RegistrationType.email,
            ),
          ),
          GoRoute(
            path: VerifyEmailOtpPage.routePath(),
            name: VerifyEmailOtpPage.name,
            builder: (context, state) => VerifyEmailOtpPage(
              extra: state.extra as VerifyOtpExtra,
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
        path: '/become_pro_intro',
        name: BecomeProIntroPage.name,
        builder: (context, state) => const BecomeProIntroPage(),
      ),
      GoRoute(
        path: '/become_pro_form',
        name: BecomeProFormPage.name,
        builder: (context, state) => const BecomeProFormPage(),
      ),
      GoRoute(
        path: ChangeCredentialsPage.path,
        name: ChangeCredentialsPage.name,
        builder: (context, state) => const ChangeCredentialsPage(),
      ),
      GoRoute(
        path: '/settings/change-contact',
        name: RequestContactChangePage.name,
        builder: (context, state) => BlocProvider(
          create: (_) => ContactChangeCubit(),
          child: RequestContactChangePage(
            type: state.extra as ContactChangeType,
          ),
        ),
        routes: [
          GoRoute(
            path: 'confirm',
            name: ConfirmContactChangePage.name,
            builder: (context, state) => BlocProvider(
              create: (_) => ContactChangeCubit(),
              child: ConfirmContactChangePage(
                type: state.extra as ContactChangeType,
              ),
            ),
          ),
        ],
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
        path: StripeResultRoute.path,
        name: StripeResultRoute.name,
        builder: (context, state) => StripeResultRoute(
          paymentIntentData: state.extra as PaymentItentData,
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
        path: PendingPaymentReservationsPage.routePath(),
        name: PendingPaymentReservationsPage.name,
        builder: (context, state) => PendingPaymentReservationsPage(
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
        path: SearchContainerPage.routePath,
        name: SearchContainerPage.routeName,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return _slideUpPage(
            state.pageKey,
            SearchContainerPage(
              homeTab: extra['homeTab'] as HomeTab?,
              lat: extra['lat'] as double?,
              lng: extra['lng'] as double?,
            ),
          );
        },
      ),
      GoRoute(
        path: SearchResultPage.routePath,
        name: SearchResultPage.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return SearchResultPage(
            category: extra['category'] as String,
            search: extra['search'] as String?,
            villeId: extra['villeId'] as String?,
            communeId: extra['communeId'] as String?,
            displayText: extra['displayText'] as String,
            bannerImageId: extra['bannerImageId'] as String?,
          );
        },
      ),
      GoRoute(
        path: '/otp-confirm',
        name: OtpPage.name,
        builder: (context, state) => OtpPage(
          currentPhoneNumber: state.extra as String,
        ),
      ),
      GoRoute(
        path: '/visit-pending',
        name: VisitPendingPage.name,
        builder: (context, state) {
          if (state.extra is VisitPendingPage) {
            final page = state.extra as VisitPendingPage;
            return VisitPendingPage(
              key: state.pageKey,
              bienImmo: page.bienImmo,
              visitType: page.visitType,
              visitId: page.visitId,
              fromHistory: page.fromHistory,
            );
          }
          return const SizedBox.shrink();
        },
      ),
      GoRoute(
        path: '/reservation-engagement',
        name: ReservationEngagementFrame.name,
        builder: (context, state) {
          if (state.extra is ReservationEngagementFrame) {
            final reservation = state.extra as ReservationEngagementFrame;
            return ReservationEngagementFrame(
              key: state.pageKey,
              ownerName: reservation.ownerName,
              reservationId: reservation.reservationId,
              montantTotal: reservation.montantTotal,
              initialState: reservation.initialState,
              onBackHome: reservation.onBackHome,
            );
          }
          return const SizedBox.shrink();
        },
      ),
      ShellRoute(
        navigatorKey: _rootNavigatorKey,
        builder: (context, state, child) {
          return HomePageWrapper(child: child);
        },
        routes: [
          GoRoute(
            path: HomePage.routePath,
            name: HomePage.name,
            pageBuilder: (context, state) => NoTransitionPage(
              child: const HomePage(),
            ),
          ),
          GoRoute(
            path: MyChoicePage.routePath,
            name: MyChoicePage.name,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MyChoicePage(),
            ),
          ),
          GoRoute(
            path: '/vivre',
            name: VivrePage.name,
            pageBuilder: (context, state) => NoTransitionPage(
              child: const VivrePage(),
            ),
            routes: [
              GoRoute(
                path: ':videoId',
                builder: (context, state) => VivrePage(
                  initialVideoId: state.pathParameters['videoId'],
                ),
              ),
            ],
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

      // Short URL redirect: /v/:code → API /short/:code → /vivre/:videoId
      GoRoute(
        path: '/v/:code',
        redirect: (context, state) async {
          final code = state.pathParameters['code']!;
          try {
            final res = await getIt<Dio>().get('/short/$code');
            final videoId = res.data['entityId'] as String?;
            if (videoId != null && videoId.isNotEmpty) {
              return '/vivre/$videoId';
            }
          } catch (_) {}
          return '/vivre';
        },
      ),

      GoRoute(
        path: ResidencePage.routePath(),
        name: ResidencePage.name,
        builder: (context, state) {
          final extra = state.extra;
          bool isImmediateBooking = false;
          String? reverseSearchId;
          double? reverseSearchPrice;

          if (extra is Map<String, dynamic>) {
            isImmediateBooking = extra['isImmediateBooking'] as bool? ?? false;
            reverseSearchId = extra['reverseSearchId'] as String?;
            reverseSearchPrice = extra['reverseSearchPrice'] as double?;
          }

          return ResidencePage(
            idProduct: state.pathParameters['idProduct'] ?? '',
            isImmediateBooking: isImmediateBooking,
            reverseSearchId: reverseSearchId,
            reverseSearchPrice: reverseSearchPrice,
          );
        },
      ),

      GoRoute(
        path: HotelSearchPage.routePath,
        name: HotelSearchPage.name,
        builder: (context, state) => const HotelSearchPage(),
      ),

      GoRoute(
        path: HotelDetailPage.routePath,
        name: HotelDetailPage.name,
        builder: (context, state) => HotelDetailPage(
          hotelId: state.pathParameters['hotelId'] ?? '',
        ),
      ),

      GoRoute(
        path: HotelBookingSelectionPage.routePath,
        name: HotelBookingSelectionPage.name,
        builder: (context, state) => HotelBookingSelectionPage(
          hotelId: state.pathParameters['hotelId'] ?? '',
          initialRoomId: state.uri.queryParameters['roomId'],
        ),
      ),

      GoRoute(
        path: HotelRoomDetailPage.routePath,
        name: HotelRoomDetailPage.name,
        builder: (context, state) => HotelRoomDetailPage(
          hotelId: state.pathParameters['hotelId'] ?? '',
          roomTypeId: state.pathParameters['roomTypeId'] ?? '',
          hotel: state.extra as HotelDetailModel?,
        ),
      ),

      GoRoute(
        path: HotelBookingSummaryPage.routePath,
        name: HotelBookingSummaryPage.name,
        builder: (context, state) => HotelBookingSummaryPage(
          data: state.extra as Map<String, dynamic>,
        ),
      ),

      GoRoute(
        path: HotelSearchResultPage.routePath,
        name: HotelSearchResultPage.name,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return _slideUpPage(
            state.pageKey,
            HotelSearchResultPage(
              destination: extra['destination'] as String? ?? '',
              lat: extra['lat'] as double?,
              long: extra['long'] as double?,
              checkInDate: extra['checkInDate'] as DateTime?,
              checkOutDate: extra['checkOutDate'] as DateTime?,
              adults: extra['adults'] as int? ?? 2,
              children: extra['children'] as int? ?? 0,
              lits: extra['lits'] as int? ?? 1,
              villeId: extra['villeId'] as String?,
            ),
          );
        },
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
        path: LocationResidencesPage.routePath,
        name: LocationResidencesPage.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return LocationResidencesPage(
            title: extra['title'] as String,
            villeId: extra['villeId'] as String?,
            communeId: extra['communeId'] as String?,
          );
        },
      ),

      GoRoute(
        path: BestRatedResidencesPage.routePath,
        name: BestRatedResidencesPage.routeName,
        builder: (context, state) => const BestRatedResidencesPage(),
      ),

      GoRoute(
        path: ReductionResidencesPage.routePath,
        name: ReductionResidencesPage.routeName,
        builder: (context, state) => const ReductionResidencesPage(),
      ),

      GoRoute(
        path: LocationBiensPage.routePath,
        name: LocationBiensPage.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return LocationBiensPage(
            title: extra['title'] as String,
            villeId: extra['villeId'] as String?,
            communeId: extra['communeId'] as String?,
            subCategory: extra['subCategory'] as EstateSubCategory?,
            propertyType:
                extra['propertyType'] as PropertyType? ?? PropertyType.land,
          );
        },
      ),

      GoRoute(
        path: LocationFurnituresPage.routePath,
        name: LocationFurnituresPage.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return LocationFurnituresPage(
            title: extra['title'] as String,
            villeId: extra['villeId'] as String?,
            communeId: extra['communeId'] as String?,
          );
        },
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
                icon: const FaIcon(FontAwesomeIcons.circleArrowLeft),
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
              icon: const FaIcon(FontAwesomeIcons.circleArrowLeft),
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
            if (type == ProductType.demandes_visites.name) {
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
        path: UserPreferencePage.routePath,
        name: UserPreferencePage.name,
        builder: (BuildContext context, GoRouterState state) {
          return const UserPreferencePage();
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
      GoRoute(
        path: AlertListPage.routePath,
        name: AlertListPage.name,
        builder: (context, state) => const AlertListPage(),
      ),
      GoRoute(
        path: '/alerts/create',
        name: AlertCreateEditPage.name,
        builder: (context, state) => AlertCreateEditPage(
          alert: state.extra as AlertModel?,
        ),
      ),
      GoRoute(
        path: AlertPropositionsPage.routePath(),
        name: AlertPropositionsPage.name,
        builder: (context, state) => AlertPropositionsPage(
          alertId: state.pathParameters['id']!,
          unreadMatchCount: (state.extra as int?) ?? 0,
        ),
      ),
      GoRoute(
        path: '/alerts/success',
        name: AlertSuccessPage.name,
        builder: (context, state) => const AlertSuccessPage(),
      ),
      GoRoute(
        path: '/alerts/detail',
        name: AlertDetailPage.name,
        builder: (context, state) => AlertDetailPage(
          alert: state.extra as AlertModel,
        ),
      ),
      GoRoute(
        path: '/notifications/detail',
        name: NotificationDetailPage.name,
        builder: (context, state) => NotificationDetailPage(
          notification: state.extra as NotificationModel,
        ),
      ),
      GoRoute(
        path: ReverseSearchMapPage.routePath,
        name: ReverseSearchMapPage.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider.value(
            value: extra['cubit'] as ReverseSearchCubit,
            child: ReverseSearchMapPage(
              request: extra['request'] as ReverseSearchRequest,
            ),
          );
        },
      ),
      GoRoute(
        path: '/kyc-webview',
        name: KycWebViewPage.routeName,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map<String, String>) {
            return KycWebViewPage(
              url: extra['url'] ?? '',
              title: extra['title'],
            );
          }
          return KycWebViewPage(
            url: extra as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: BookingDetailPage.routePath,
        name: BookingDetailPage.name,
        builder: (context, state) => BookingDetailPage(
          id: state.pathParameters['id']!,
          autoShowRating: state.uri.queryParameters['action'] == 'rate',
        ),
      ),
      GoRoute(
        path: RatingHistoryPage.routePath(),
        name: RatingHistoryPage.name,
        builder: (context, state) => const RatingHistoryPage(),
      ),
    ],
  );
}

/// Slide-up + fade-in page transition — shared between SuggestPage and HotelSearchResultPage.
CustomTransitionPage<void> _slideUpPage(LocalKey key, Widget child) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 260),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.12),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(opacity: curved, child: child),
      );
    },
  );
}
