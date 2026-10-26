import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/enums/analytics/analytics_event.dart';
import 'package:immoplus/app/core/enums/analytics/banner_cta_slot.dart';
import 'package:immoplus/app/core/enums/analytics/home_grid_tab.dart';
import 'package:immoplus/app/core/enums/analytics/residence_entry_point.dart';
import 'package:immoplus/app/core/enums/analytics/transaction_item_type.dart';
import 'package:immoplus/app/core/services/crashlytics_service.dart';
import 'package:immoplus/app/data/models/local/user_model_schema.dart';
import 'package:immoplus/app/data/models/remote/banners/banner_model.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@lazySingleton
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // ── Identité utilisateur ────────────────────────────────────────────────
  Future<void> setUserIdentity({
    required UserModelSchema user,
    String? kycStatus,
    String? city,
    String? accountType,
    String? intentPreference,
  }) async {
    await _analytics.setUserId(id: user.userId);
    if (user.userId != null) {
      try {
        await getIt<CrashlyticsService>().setUserId(user.userId!);
      } catch (_) {}
    }

    final packageInfo = await PackageInfo.fromPlatform();
    final platform = Platform.isIOS ? 'ios' : 'android';

    await Future.wait([
      _analytics.setUserProperty(name: 'user_role', value: 'customer'),
      _analytics.setUserProperty(
          name: 'account_type', value: accountType ?? 'particulier'),
      _analytics.setUserProperty(name: 'city', value: city),
      _analytics.setUserProperty(name: 'kyc_status', value: kycStatus),
      _analytics.setUserProperty(
          name: 'intent_preference', value: intentPreference),
      _analytics.setUserProperty(name: 'device_platform', value: platform),
      _analytics.setUserProperty(
          name: 'app_version', value: packageInfo.version),
    ]);
  }

  Future<void> clearUserIdentity() async {
    await _analytics.setUserId(id: null);
    try {
      await getIt<CrashlyticsService>().clearUserId();
    } catch (_) {}
  }

  Future<void> updateKycStatus(String status) async {
    await _analytics.setUserProperty(name: 'kyc_status', value: status);
  }

  // ── Authentification ────────────────────────────────────────────────────
  Future<void> logSignUp({required String method}) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  Future<void> logLogin({required String method}) async {
    await _analytics.logLogin(loginMethod: method);
  }

  // ── Recherche & navigation ──────────────────────────────────────────────
  Future<void> logSearch({
    required String searchTerm,
    String? searchLocation,
    String? searchType,
  }) async {
    await _analytics.logSearch(
      searchTerm: searchTerm,
      parameters: {
        if (searchLocation != null) 'search_location': searchLocation,
        if (searchType != null) 'search_type': searchType,
      },
    );
  }

  Future<void> logFilterApplied({
    String? filterLocation,
    String? filterDateStart,
    String? filterDateEnd,
    String? filterType,
    int? filterBudgetMin,
    int? filterBudgetMax,
  }) async {
    await _analytics.logEvent(
      name: 'filter_applied',
      parameters: {
        if (filterLocation != null) 'filter_location': filterLocation,
        if (filterDateStart != null) 'filter_date_start': filterDateStart,
        if (filterDateEnd != null) 'filter_date_end': filterDateEnd,
        if (filterType != null) 'filter_type': filterType,
        if (filterBudgetMin != null) 'filter_budget_min': filterBudgetMin,
        if (filterBudgetMax != null) 'filter_budget_max': filterBudgetMax,
      },
    );
  }

  Future<void> logMapViewOpened() async {
    await _analytics.logEvent(name: 'map_view_opened');
  }

  Future<void> logNearResidencesViewed() async {
    await _analytics.logEvent(name: 'near_residences_viewed');
  }

  Future<void> logChatGuidanceEvent({
    required String eventName,
    required String ruleId,
    required String intent,
    required String conversationType,
    String? reservationStatus,
  }) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: {
        'rule_id': ruleId,
        'intent': intent,
        'conversation_type': conversationType,
        if (reservationStatus != null) 'reservation_status': reservationStatus,
      },
    );
  }

  // ── Consultation de fiches ──────────────────────────────────────────────
  Future<void> logViewResidence({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required String itemLocation,
    required double price,
    ResidenceEntryPoint? entryPoint,
  }) async {
    await _analytics.logViewItem(
      currency: 'XOF',
      value: price,
      items: [
        AnalyticsEventItem(
          itemId: itemId,
          itemName: itemName,
          itemCategory: itemCategory,
          itemVariant: itemLocation,
          price: price,
        ),
      ],
      parameters: _entryPointParams(entryPoint),
    );
  }

  Future<void> logViewEstate({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required double price,
  }) async {
    await _analytics.logViewItem(
      currency: 'XOF',
      value: price,
      items: [
        AnalyticsEventItem(
          itemId: itemId,
          itemName: itemName,
          itemCategory: itemCategory,
          price: price,
        ),
      ],
    );
  }

  Future<void> logAddToWishlist({
    required String itemId,
    required String itemName,
    required String itemCategory,
  }) async {
    await _analytics.logAddToWishlist(
      currency: 'XOF',
      items: [
        AnalyticsEventItem(
          itemId: itemId,
          itemName: itemName,
          itemCategory: itemCategory,
        ),
      ],
    );
  }

  Future<void> logResidenceVideoPlayed({
    required String residenceId,
    required String videoId,
  }) async {
    await _analytics.logEvent(
      name: 'residence_video_played',
      parameters: {
        'residence_id': residenceId,
        'video_id': videoId,
      },
    );
  }

  Future<void> logResidenceShared({required String residenceId}) async {
    await _analytics.logShare(
      contentType: 'residence',
      itemId: residenceId,
      method: 'share_sheet',
    );
  }

  Future<void> logVisitRequestSubmitted({
    required String estateId,
    required String estateName,
  }) async {
    await _analytics.logEvent(
      name: 'visit_request_submitted',
      parameters: {
        'estate_id': estateId,
        'estate_name': estateName,
      },
    );
  }

  // ── Funnel de réservation ───────────────────────────────────────────────
  Future<void> logResidenceBookingCtaTapped({
    required String residenceId,
    required String residenceName,
    required double price,
    ResidenceEntryPoint? entryPoint,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEvent.residenceBookingCtaTapped.value,
      parameters: {
        'residence_id': residenceId,
        'residence_name': residenceName,
        'price': price,
        ..._entryPointParams(entryPoint),
      },
    );
  }

  Future<void> logBeginCheckout({
    required String itemId,
    required String itemName,
    required double value,
    String currency = 'XOF',
    String? dateStart,
    String? dateEnd,
    ResidenceEntryPoint? entryPoint,
  }) async {
    await _analytics.logBeginCheckout(
      currency: currency,
      value: value,
      items: [
        AnalyticsEventItem(itemId: itemId, itemName: itemName, price: value),
      ],
      parameters: {
        if (dateStart != null) 'date_start': dateStart,
        if (dateEnd != null) 'date_end': dateEnd,
        ..._entryPointParams(entryPoint),
      },
    );
  }

  Future<void> logAddPaymentInfo({
    required String paymentType,
    required double value,
    String currency = 'XOF',
    required String itemId,
  }) async {
    await _analytics.logAddPaymentInfo(
      currency: currency,
      value: value,
      paymentType: paymentType,
      items: [AnalyticsEventItem(itemId: itemId)],
    );
  }

  Future<void> logPurchase({
    required String transactionId,
    required double value,
    String currency = 'XOF',
    required String paymentMethod,
    required String itemId,
    required String itemName,
  }) async {
    await _analytics.logPurchase(
      transactionId: transactionId,
      currency: currency,
      value: value,
      items: [AnalyticsEventItem(itemId: itemId, itemName: itemName)],
      parameters: {'payment_method': paymentMethod},
    );
  }

  // ── Alertes Imatch ──────────────────────────────────────────────────────
  Future<void> logAlertSubmitted({
    String? propertyType,
    String? location,
    int? budgetMin,
    int? budgetMax,
  }) async {
    await _analytics.logEvent(
      name: 'alert_submitted',
      parameters: {
        if (propertyType != null) 'property_type': propertyType,
        if (location != null) 'location': location,
        if (budgetMin != null) 'budget_min': budgetMin,
        if (budgetMax != null) 'budget_max': budgetMax,
      },
    );
  }

  Future<void> logAlertMatchesViewed({required String alertId}) async {
    await _analytics.logEvent(
      name: 'alert_matches_viewed',
      parameters: {'alert_id': alertId},
    );
  }

  // ── Notifications push ──────────────────────────────────────────────────
  // ── Accueil ─────────────────────────────────────────────────────────────
  Future<void> logHomeTabTapped(HomeGridTab tab) =>
      _logEvent(AnalyticsEvent.homeTabTapped, {'tab': tab.analyticsValue});

  Future<void> logTransactionsFabOpened({
    required int pendingOwnerCount,
    required int pendingPaymentCount,
    required bool hasReverseSearch,
  }) {
    final total =
        pendingOwnerCount + pendingPaymentCount + (hasReverseSearch ? 1 : 0);
    return _logEvent(AnalyticsEvent.transactionsFabOpened, {
      'pending_count': total,
      'pending_owner_count': pendingOwnerCount,
      'pending_payment_count': pendingPaymentCount,
      'has_reverse_search': hasReverseSearch ? 1 : 0,
      'has_pending': total > 0 ? 1 : 0,
    });
  }

  Future<void> logTransactionItemTapped(TransactionItemType type,
          {String? itemId}) =>
      _logEvent(AnalyticsEvent.transactionItemTapped, {
        'transaction_type': type.analyticsValue,
        if (itemId != null) 'item_id': itemId,
      });

  Future<void> logBannerCtaTapped(
    BannerModel banner, {
    required BannerCtaSlot slot,
    String? ctaUrl,
  }) =>
      _logEvent(AnalyticsEvent.bannerCtaTapped, {
        ..._bannerParams(banner),
        'cta_slot': slot.analyticsValue,
        if (ctaUrl != null) 'cta_url': ctaUrl,
      });

  Future<void> logBannerDismissed(BannerModel banner) =>
      _logEvent(AnalyticsEvent.bannerDismissed, _bannerParams(banner));

  Future<void> logBannerViewed(BannerModel banner, {required int position}) =>
      _logEvent(AnalyticsEvent.bannerViewed, {
        ..._bannerParams(banner),
        'position': position,
      });

  /// Intention de recherche : tap initial sur la barre, avant toute frappe.
  Future<void> logSearchBarFocused() =>
      _logEvent(AnalyticsEvent.searchBarFocused);

  // ── Onboarding ──────────────────────────────────────────────────────────
  Future<void> logOnboardingCtaSignupTapped() =>
      _logEvent(AnalyticsEvent.onboardingCtaSignupTapped);

  Future<void> logOnboardingGuestModeTapped() =>
      _logEvent(AnalyticsEvent.onboardingGuestModeTapped);

  Future<void> logOnboardingCompleted() =>
      _logEvent(AnalyticsEvent.onboardingCompleted);

  // ── Navigation principale ───────────────────────────────────────────────
  Future<void> logTabReelsTapped() => _logEvent(AnalyticsEvent.tabReelsTapped);

  Future<void> logTabImatchTapped() =>
      _logEvent(AnalyticsEvent.tabImatchTapped);

  // ── Helpers ─────────────────────────────────────────────────────────────
  Future<void> _logEvent(
    AnalyticsEvent event, [
    Map<String, Object>? parameters,
  ]) {
    return _analytics.logEvent(name: event.value, parameters: parameters);
  }

  Map<String, Object> _entryPointParams(ResidenceEntryPoint? entryPoint) => {
        if (entryPoint != null)
          ResidenceEntryPoint.queryKey: entryPoint.analyticsValue,
      };

  Map<String, Object> _bannerParams(BannerModel banner) => {
        if (banner.id != null) 'banner_id': banner.id!.toString(),
        if (banner.type != null) 'banner_type': banner.type!,
        if (banner.title != null) 'banner_title': banner.title!,
      };

  Future<void> logNotificationReceived({
    required String notificationType,
    String? notificationId,
  }) async {
    await _analytics.logEvent(
      name: 'notification_received',
      parameters: {
        'notification_type': notificationType,
        if (notificationId != null) 'notification_id': notificationId,
      },
    );
  }

  Future<void> logNotificationTapped({
    required String notificationType,
    String? notificationId,
  }) async {
    await _analytics.logEvent(
      name: 'notification_tapped',
      parameters: {
        'notification_type': notificationType,
        if (notificationId != null) 'notification_id': notificationId,
      },
    );
  }

  // ── Deep links ──────────────────────────────────────────────────────────
  Future<void> logDeepLinkOpened({
    required String linkUrl,
    String utmSource = 'direct',
    String utmMedium = 'none',
    String utmCampaign = 'none',
  }) async {
    await _analytics.logEvent(
      name: 'deep_link_opened',
      parameters: {
        'link_url': linkUrl,
        'utm_source': utmSource,
        'utm_medium': utmMedium,
        'utm_campaign': utmCampaign,
      },
    );
  }
}
