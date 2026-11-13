import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:immoplus/app/core/error/app_error_mapper.dart';
import 'package:immoplus/app/core/error/app_error.dart';
import 'package:immoplus/app/core/error/error_context.dart';
import 'package:immoplus/app/core/error/error_messages.dart';
import 'package:immoplus/app/core/error/error_presenter.dart';
import 'package:immoplus/app/core/services/crashlytics_service.dart';
import 'package:injectable/injectable.dart';

/// Point d'entrée unique pour présenter une erreur à l'utilisateur.
///
/// Les features lui passent une [AppError] typée, un [ErrorContext] et, si
/// l'opération est sûre à relancer, une action `retry`. Il décide du canal :
///
/// | Erreur                    | Retour                                          |
/// |---------------------------|-------------------------------------------------|
/// | silencieuse               | aucun (télémétrie seulement)                    |
/// | réseau                    | dialogue unique, relance auto au retour réseau  |
/// | session expirée (401)     | dialogue « Se reconnecter »                     |
/// | validation avec champs    | rien : la feature affiche les erreurs inline    |
/// | validation sans champ     | toast                                           |
/// | contexte bloquant         | rien : l'écran affiche son état « Réessayer »   |
/// | métier / serveur / autre  | dialogue standard (+ « Réessayer » si possible) |
@lazySingleton
class ErrorFeedbackCoordinator {
  ErrorFeedbackCoordinator(this._presenter, this._crashlytics)
      : _now = DateTime.now;

  @visibleForTesting
  ErrorFeedbackCoordinator.withClock(
    this._presenter,
    this._crashlytics,
    this._now,
  );

  /// Une même erreur n'est pas représentée avant ce délai.
  static const dedupeWindow = Duration(seconds: 4);

  final ErrorPresenter _presenter;
  final CrashlyticsService _crashlytics;
  final DateTime Function() _now;

  final Map<String, DateTime> _lastShown = {};
  bool _dialogOpen = false;
  bool _offlineVisible = false;

  void present({
    required AppError error,
    required ErrorContext context,
    FutureOr<void> Function()? retry,
  }) {
    _report(error, context);
    if (error.silent) return;
    if (_isDuplicate(error, context)) return;

    switch (error) {
      case NetworkError():
        _presentOffline(retry);
      case UnauthorizedError():
        _presentDialog(
          error,
          context,
          actionLabel: 'Se reconnecter',
          onAction: _presenter.openSignIn,
        );
      case ValidationError(:final hasFieldErrors):
        if (!hasFieldErrors) {
          final text = ErrorMessages.describe(error, context);
          _presenter.showToast(title: text.title, message: text.message);
        }
      default:
        // L'écran porte déjà l'erreur de chargement principal (avec
        // « Réessayer ») : pas de second retour par-dessus.
        if (context.blocksContent) return;
        final canRetry = error.retryable && retry != null;
        _presentDialog(
          error,
          context,
          actionLabel: canRetry ? 'Réessayer' : null,
          onAction: canRetry ? retry : null,
        );
    }
  }

  /// Variante pour un `catch` : accepte l'objet attrapé, mais ne présente que
  /// les erreurs réseau/API ([AppError], `DioException`). Les autres
  /// (localisation, parsing, plugins…) ne concernent pas ce canal : elles
  /// ne sont pas affichées ici. Retourne `false` quand rien n'a été présenté
  /// (erreur hors API, ou requête silencieuse) pour que l'appelant applique
  /// son propre retour.
  bool presentThrown(
    Object thrown, {
    required ErrorContext context,
    FutureOr<void> Function()? retry,
  }) {
    if (thrown is! AppError && thrown is! DioException) return false;
    final error = AppErrorMapper.from(thrown);
    present(error: error, context: context, retry: retry);
    // Erreur silencieuse : rien n'a été affiché, l'appelant garde son retour.
    return !error.silent;
  }

  /// Les erreurs déjà visibles ailleurs (ex: état d'erreur inline) peuvent
  /// lever la dédup pour permettre un nouvel essai immédiat.
  void resetDeduplication() => _lastShown.clear();

  void _presentOffline(FutureOr<void> Function()? retry) {
    // Une seule perte de connexion affichée à la fois.
    if (_offlineVisible) return;
    _offlineVisible = true;
    unawaited(
      _presenter
          .showOfflineDialog(onRestored: retry)
          .whenComplete(() => _offlineVisible = false),
    );
  }

  /// À appeler quand le réseau est de retour : ferme le dialogue ouvert.
  void onConnectionRestored() {
    if (!_offlineVisible) return;
    _presenter.hideOfflineDialog();
  }

  Future<void> _presentDialog(
    AppError error,
    ErrorContext context, {
    String? actionLabel,
    FutureOr<void> Function()? onAction,
  }) async {
    // Jamais deux dialogues d'erreur empilés.
    if (_dialogOpen) return;
    _dialogOpen = true;
    try {
      final text = ErrorMessages.describe(error, context);
      await _presenter.showDialog(
        title: text.title,
        message: text.message,
        actionLabel: actionLabel,
        onAction: onAction,
        reference: error.requestId,
      );
    } finally {
      _dialogOpen = false;
    }
  }

  bool _isDuplicate(AppError error, ErrorContext context) {
    final key = '${error.runtimeType}:${error.code}:${context.name}';
    final now = _now();
    final last = _lastShown[key];
    if (last != null && now.difference(last) < dedupeWindow) return true;
    _lastShown[key] = now;
    return false;
  }

  StackTrace? _stackOf(AppError error) {
    final cause = error.cause;
    return cause is DioException ? cause.stackTrace : null;
  }

  /// Télémétrie : seules les erreurs inattendues (serveur / inconnues) sont
  /// remontées ; les autres sont de simples breadcrumbs.
  void _report(AppError error, ErrorContext context) {
    final unexpected = error is ServerError || error is UnknownError;
    if (!unexpected) {
      unawaited(_crashlytics.log('error:${error.runtimeType}:${context.name}'));
      return;
    }
    unawaited(_crashlytics.recordNonFatalError(
      // On remonte l'AppError (type, code, statut) et non la DioException
      // d'origine : celle-ci embarque URL, en-têtes et corps de réponse.
      exception: error,
      stackTrace: _stackOf(error),
      screen: context.name,
      feature: 'error_feedback',
      errorType: error.runtimeType.toString(),
      additionalContext: {
        if (error.code != null) 'code': error.code!,
        if (error.requestId != null) 'request_id': error.requestId!,
        if (error.statusCode != null) 'status': error.statusCode!,
      },
    ));
  }
}
