import 'package:flutter/widgets.dart';

/// Contrat abstrait pour le service Crashlytics (Clean Architecture).
///
/// Ce contrat permet d'isoler le reste de l'application (domain, presentation, features)
/// de l'implémentation concrète (Firebase Crashlytics, Sentry, etc.) et facilite
/// les tests unitaires via des mocks.
abstract class CrashlyticsService {
  /// Initialise la configuration et applique la politique de consentement enregistrée.
  Future<void> init();

  /// Active ou désactive la collecte selon la politique de consentement de l'application.
  Future<void> setCollectionEnabled(bool enabled);

  /// Vérifie si la collecte Crashlytics est actuellement activée.
  Future<bool> isCollectionEnabled();

  /// Associe l'identifiant technique anonyme de l'utilisateur (userId interne uniquement).
  /// Ne jamais passer de numéro de téléphone, email ou identité directe.
  Future<void> setUserId(String userId);

  /// Réinitialise l'identifiant utilisateur (ex: déconnexion).
  Future<void> clearUserId();

  /// Enregistre un fil d'ariane (breadcrumb / log structuré) sans donnée personnelle.
  Future<void> log(String message);

  /// Définit une clé personnalisée non sensible utile au diagnostic.
  Future<void> setCustomKey(String key, Object value);

  /// Remonte manuellement une erreur non fatale inattendue bloquant un parcours utilisateur.
  ///
  /// Contexte requis non sensible :
  /// - [exception] : l'erreur rencontrée
  /// - [stackTrace] : stack trace associée
  /// - [screen] : nom de l'écran (ex: "BookingPage")
  /// - [feature] : nom de la feature (ex: "payment", "booking")
  /// - [errorType] : type d'erreur technique (ex: "PaymentProcessingError")
  /// - [reason] : explication brève et non sensible du problème
  /// - [additionalContext] : métadonnées complémentaires filtrées
  Future<void> recordNonFatalError({
    required dynamic exception,
    required StackTrace? stackTrace,
    required String screen,
    required String feature,
    String? errorType,
    String? reason,
    Map<String, Object>? additionalContext,
  });

  /// Mécanisme de test DEV / QA : génère une exception contrôlée non fatale.
  Future<void> triggerControlledNonFatalError();

  /// Mécanisme de test DEV / QA : génère une erreur asynchrone non interceptée.
  void triggerControlledAsyncError();

  /// Mécanisme de test DEV / QA : déclenche un crash fatal contrôlé.
  void triggerControlledFatalCrash();
}

/// Observateur de navigation pour alimenter les breadcrumbs et l'écran courant
/// dans Crashlytics sans données sensibles.
class CrashlyticsRouteObserver extends NavigatorObserver {
  final CrashlyticsService _crashlyticsService;

  CrashlyticsRouteObserver(this._crashlyticsService);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final screenName = route.settings.name;
    if (screenName != null && screenName.isNotEmpty) {
      _crashlyticsService.log('Screen viewed: $screenName');
      _crashlyticsService.setCustomKey('current_screen', screenName);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    final screenName = previousRoute?.settings.name;
    if (screenName != null && screenName.isNotEmpty) {
      _crashlyticsService.log('Screen returned to: $screenName');
      _crashlyticsService.setCustomKey('current_screen', screenName);
    }
  }
}
