import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:immoplus/app/data/models/local/user_model_schema.dart';
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

  // ── Consultation de fiches ──────────────────────────────────────────────
  Future<void> logViewResidence({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required String itemLocation,
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
          itemVariant: itemLocation,
          price: price,
        ),
      ],
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
  }) async {
    await _analytics.logEvent(
      name: 'residence_booking_cta_tapped',
      parameters: {
        'residence_id': residenceId,
        'residence_name': residenceName,
        'price': price,
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
