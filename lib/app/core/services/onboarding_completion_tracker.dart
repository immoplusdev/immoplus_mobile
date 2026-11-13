import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/services/analytics_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Suit la fin du parcours onboarding → préférences → page intermédiaire.
///
/// L'événement `onboarding_completed` n'est émis qu'à la première arrivée sur
/// l'accueil qui suit ce parcours (jamais pour un utilisateur existant).
class OnboardingCompletionTracker {
  OnboardingCompletionTracker._();

  static const _pendingKey = 'onboarding_completion_pending';

  /// À appeler quand l'utilisateur termine l'onboarding.
  static Future<void> markPending() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pendingKey, true);
  }

  /// À appeler à l'arrivée sur l'accueil : émet l'événement une seule fois.
  static Future<void> logIfPending() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_pendingKey) != true) return;
    await prefs.setBool(_pendingKey, false);
    await getIt<AnalyticsService>().logOnboardingCompleted();
  }
}
