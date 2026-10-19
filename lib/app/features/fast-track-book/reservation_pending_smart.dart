import 'package:flutter/foundation.dart';

/// États d'engagement de la réservation (partagé avec [ReservationEngagementFrame])
enum ReservationBannerState {
  idle,
  waitingOwner,
  waitingPayment,
  endedRefused,
  endedWaitingExpired,
  endedPaymentExpired,
}

/// Événements et notifiers statiques de synchronisation des réservations.
/// Le widget visuel historique a été retiré au profit de [TransactionsFloatingButton].
class ReservationPendingBanner {
  ReservationPendingBanner._();

  // ── Notifier : refresh externe (création / annulation / reload) ─────────────
  static final ValueNotifier<int> refreshNotifier = ValueNotifier<int>(0);
  static void refresh() => refreshNotifier.value++;

  // ── Notifier : soft refresh (re-fetch silencieux) ──────────────────────────
  static final ValueNotifier<int> softRefreshNotifier = ValueNotifier<int>(0);
  static void softRefresh() => softRefreshNotifier.value++;

  // ── Notifier : présence réservation ────────────────────────────────────────
  static final ValueNotifier<bool> hasReservationNotifier =
      ValueNotifier<bool>(false);
  static void setHasReservation(bool value) =>
      hasReservationNotifier.value = value;

  // ── Notifier : état global partagé ─────────────────────────────────────────
  static final ValueNotifier<ReservationBannerState> bannerStateNotifier =
      ValueNotifier<ReservationBannerState>(ReservationBannerState.idle);

  // ── Notifier : deadline ISO brute ──────────────────────────────────────────
  static final ValueNotifier<String?> deadlineNotifier =
      ValueNotifier<String?>(null);

  // ── Notifier : secondes totales ────────────────────────────────────────────
  static final ValueNotifier<int> totalSecondsNotifier = ValueNotifier<int>(1);

  // ── Notifier : push notification ou socket update reçus ────────────────────
  static final ValueNotifier<int> pushNotifier = ValueNotifier<int>(0);
  static void onPushReceived() => pushNotifier.value++;
}
