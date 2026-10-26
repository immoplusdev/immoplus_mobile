import 'dart:async';

import 'package:immoplus/app/core/config/injection.dart';
import 'package:immoplus/app/core/error/app_error.dart';
import 'package:immoplus/app/core/error/error_context.dart';
import 'package:immoplus/app/core/error/error_feedback_coordinator.dart';

/// Façade d'accès à [ErrorFeedbackCoordinator] pour les `catch` des features.
///
/// ```dart
/// try { await repository.submit(); }
/// catch (e) { ErrorFeedback.show(e, context: ErrorContext.bookingSubmission); }
/// ```
///
/// `retry` : à fournir uniquement si l'opération est sûre à relancer
/// (lecture, envoi d'un code…). Jamais pour un paiement ou une création.
abstract final class ErrorFeedback {
  static ErrorFeedbackCoordinator get _coordinator =>
      getIt<ErrorFeedbackCoordinator>();

  /// Présente l'exception attrapée si c'est une erreur d'API ([AppError] ou
  /// `DioException`) et retourne `true`. Sinon (plugin, parsing…) ne fait
  /// rien et retourne `false`, pour que l'appelant applique son propre retour.
  static bool show(
    Object thrown, {
    required ErrorContext context,
    FutureOr<void> Function()? retry,
  }) =>
      _coordinator.presentThrown(thrown, context: context, retry: retry);

  /// Présente une [AppError] déjà typée.
  static void present(
    AppError error, {
    required ErrorContext context,
    FutureOr<void> Function()? retry,
  }) =>
      _coordinator.present(error: error, context: context, retry: retry);

  /// Le réseau est de retour : ferme le dialogue « Pas de connexion ».
  static void connectionRestored() => _coordinator.onConnectionRestored();
}
