/// Noms des événements Firebase Analytics personnalisés de l'accueil, de
/// l'onboarding et de la navigation (les événements standards GA4 passent
/// par les méthodes dédiées de `FirebaseAnalytics`).
enum AnalyticsEvent {
  homeTabTapped('home_tab_tapped'),
  transactionsFabOpened('transactions_fab_opened'),
  transactionItemTapped('transaction_item_tapped'),
  bannerCtaTapped('banner_cta_tapped'),
  bannerDismissed('banner_dismissed'),
  bannerViewed('banner_viewed'),
  searchBarFocused('search_bar_focused'),
  onboardingCtaSignupTapped('onboarding_cta_signup_tapped'),
  onboardingGuestModeTapped('onboarding_guest_mode_tapped'),
  onboardingCompleted('onboarding_completed'),
  tabReelsTapped('tab_reels_tapped'),
  tabImatchTapped('tab_imatch_tapped'),
  residenceBookingCtaTapped('residence_booking_cta_tapped');

  const AnalyticsEvent(this.value);

  final String value;
}
