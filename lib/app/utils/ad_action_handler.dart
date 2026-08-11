import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus/app/constants/constantes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:immoplus/app/data/enums/ad_action.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/extensions/go_router_extensions.dart';
import 'package:immoplus/app/features/booking/widgets/kyc_webview_page.dart';
import 'package:immoplus/app/features/suggest/pages/search_result_page.dart';
import 'package:immoplus/app/features/estate_detail/estate_page.dart';
import 'package:immoplus/app/features/residence_detail/residence_page.dart';
import 'package:immoplus/app/features/hotel/pages/hotel_detail_page.dart';
import 'package:immoplus/app/features/account/pages/edit_account.dart';
import 'package:immoplus/app/features/my_choice/my_choice_page.dart';
import 'package:immoplus/app/features/notification/pages/notification_page.dart';
import 'package:immoplus/app/features/booking/booking_detail_page.dart';
import 'package:immoplus/app/logic/bloc/navigation_cubit.dart';
import 'package:immoplus/app/logic/ads/ads_cubit.dart';
import 'package:immoplus/app/routes/app_router.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/network/utils/session_manager.dart';
import 'package:immoplus/app/core/services/auth_redirect_service.dart';
import 'package:immoplus/app/features/authentification/authentification_page.dart';

class AdActionHandler {
  static void handleAdAction(BuildContext context, AdCampaignModel campaign) {
    log("campaign======> ${campaign.toJson().toString()}");
    final action = AdAction.fromString(campaign.action);
    final scope = campaign.scope;
    final url = campaign.url;

    // Report click statistics to API
    context.read<AdsCubit>().trackClick(campaign.id, campaign.placement);

    log('AdActionHandler: Triggering action $action for campaign ${campaign.id}');

    switch (action) {
      case AdAction.openUrl:
        if (url != null && url.isNotEmpty) {
          context.pushNamed(
            KycWebViewPage.routeName,
            extra: {
              'url': url,
              'title': campaign.content.title ?? "",
            },
          );
        }
        break;

      case AdAction.openProperty:
        if (scope?.entityId != null) {
          AppRouter.router.pushIfDifferent(EstatePage.route(scope!.entityId!));
        }
        break;

      case AdAction.openResidence:
        if (scope?.entityId != null) {
          AppRouter.router
              .pushIfDifferent(ResidencePage.route(scope!.entityId!));
        }
        break;

      case AdAction.openHotel:
        if (scope?.entityId != null) {
          AppRouter.router
              .pushIfDifferent(HotelDetailPage.route(scope!.entityId!));
        }
        break;

      case AdAction.openLocation:
        if (scope?.entityId != null) {
          AppRouter.router.pushIfDifferent(EstatePage.route(scope!.entityId!));
        }
        break;

      case AdAction.openCategory:
        final filters = scope?.filters ?? {};
        context.push(SearchResultPage.routePath, extra: {
          'category': filters['category']?.toString() ?? 'residence',
          'search': filters['search']?.toString(),
          'villeId': filters['ville_id']?.toString(),
          'communeId': filters['commune_id']?.toString(),
          'displayText': filters['display_text']?.toString() ?? 'Résultats',
        });
        break;

      case AdAction.openProfile:
        _runWithAuthGuard(context, () {
          context.pushNamed(EditAccountPage.name);
        });
        break;

      case AdAction.openImatch:
        context.read<NavigationCubit>().switchPage(PageState.forMe);
        AppRouter.router.pushIfDifferent(MyChoicePage.routePath);
        break;

      case AdAction.openEvent:
        _runWithAuthGuardAndPass(() {
          AppRouter.router.pushIfDifferent('/${NotificationsPage.name}');
        });
        break;

      case AdAction.openExternal:
        final appUrl = scope?.filters['app_url']?.toString() ?? campaign.url;
        if (appUrl != null && appUrl.isNotEmpty) {
          launchUrl(Uri.parse(appUrl), mode: LaunchMode.externalApplication);
        }
        break;

      case AdAction.openInternalPage:
        final pageSlug = scope?.filters['page_slug']?.toString();
        if (pageSlug != null && pageSlug.isNotEmpty) {
          final target = pageSlug.startsWith('/') ? pageSlug : '/$pageSlug';
          AppRouter.router.pushIfDifferent(target);
        }
        break;

      case AdAction.openPayment:
        final bookingId = scope?.filters['booking_id']?.toString();
        if (bookingId != null && bookingId.isNotEmpty) {
          AppRouter.router
              .pushIfDifferent(BookingDetailPage.paymentRoute(bookingId));
        }
        break;

      case AdAction.none:
      default:
        break;
    }
  }

  static void _runWithAuthGuard(BuildContext context, VoidCallback action) {
    final sessionManager = getIt<SessionManager>();
    if (sessionManager.currentUser == null) {
      final currentRouteName = ModalRoute.of(context)?.settings.name;
      getIt<AuthRedirectService>().set((
        popUntilRouteName: currentRouteName,
        callback: action,
      ));
      context.pushNamed(AuthenticationPage.name);
    } else {
      action();
    }
  }

  static void _runWithAuthGuardAndPass(VoidCallback action) {
    final sessionManager = getIt<SessionManager>();
    if (sessionManager.currentUser != null) {
      action();
    }
  }
}
