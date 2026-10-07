import 'package:immoplus/app/core/services/push/push_message.dart';

/// Contrat d'un fournisseur de notifications push (Clean Architecture).
///
/// Permet d'interchanger le fournisseur (Firebase, OneSignal, etc.)
/// sans impacter `NotificationService` ni le reste de l'application.
abstract class PushProvider {
  /// Initialise la configuration du provider (plugins, permissions, canaux...).
  Future<void> initialize();

  /// Récupère le token push actuel de l'appareil.
  Future<String?> getToken();

  /// Supprime / réinitialise le token push actuel.
  Future<void> deleteToken();

  /// Flux émettant le nouveau token à chaque rafraîchissement.
  Stream<String> get onTokenRefresh;

  /// Flux des notifications reçues au premier plan (Foreground).
  Stream<PushMessage> get onForegroundMessage;

  /// Flux des notifications cliquées depuis l'arrière-plan (Background).
  Stream<PushMessage> get onNotificationOpenedApp;

  /// Récupère la notification ayant ouvert l'application à froid (Terminated state).
  Future<PushMessage?> getInitialMessage();

  /// Demande la permission de notification au système.
  Future<bool> requestPermission();
}
