import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:immoplus/app/core/error/app_error.dart';
import 'package:immoplus/app/core/error/error_context.dart';
import 'package:immoplus/app/core/error/error_feedback_coordinator.dart';
import 'package:immoplus/app/core/error/error_presenter.dart';
import 'package:immoplus/app/core/services/crashlytics_service.dart';

class _FakePresenter implements ErrorPresenter {
  final dialogs = <({String title, String message, String? actionLabel})>[];
  final toasts = <String>[];
  var offlineDialogs = 0;
  var hiddenOfflineDialogs = 0;
  Completer<void>? offlineClosed;
  var signInOpened = 0;
  FutureOr<void> Function()? lastAction;
  FutureOr<void> Function()? lastRestored;

  @override
  Future<void> showDialog({
    required String title,
    required String message,
    String? actionLabel,
    FutureOr<void> Function()? onAction,
    String? reference,
  }) async {
    dialogs.add((title: title, message: message, actionLabel: actionLabel));
    lastAction = onAction;
  }

  @override
  void showToast({required String title, required String message}) =>
      toasts.add(title);

  @override
  Future<void> showOfflineDialog({FutureOr<void> Function()? onRestored}) {
    offlineDialogs++;
    lastRestored = onRestored;
    offlineClosed = Completer<void>();
    return offlineClosed!.future;
  }

  @override
  void hideOfflineDialog() {
    hiddenOfflineDialogs++;
    offlineClosed?.complete();
  }

  @override
  void openSignIn() => signInOpened++;
}

class _FakeCrashlytics implements CrashlyticsService {
  final recorded = <String>[];

  @override
  Future<void> recordNonFatalError({
    required dynamic exception,
    required StackTrace? stackTrace,
    required String screen,
    required String feature,
    String? errorType,
    String? reason,
    Map<String, Object>? additionalContext,
  }) async {
    recorded.add('$errorType@$screen');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

void main() {
  late _FakePresenter presenter;
  late _FakeCrashlytics crashlytics;
  late DateTime now;
  late ErrorFeedbackCoordinator coordinator;

  setUp(() {
    presenter = _FakePresenter();
    crashlytics = _FakeCrashlytics();
    now = DateTime(2026, 1, 1, 12);
    coordinator = ErrorFeedbackCoordinator.withClock(
      presenter,
      crashlytics,
      () => now,
    );
  });

  test('erreur silencieuse : aucun retour utilisateur', () {
    coordinator.present(
      error: const ServerError(silent: true),
      context: ErrorContext.generic,
    );
    expect(presenter.dialogs, isEmpty);
    expect(presenter.toasts, isEmpty);
  });

  test('erreur serveur : dialogue contextualisé, sans texte générique', () {
    coordinator.present(
      error: const ServerError(statusCode: 500),
      context: ErrorContext.bookingSubmission,
    );
    final dialog = presenter.dialogs.single;
    expect(dialog.title, ErrorContext.bookingSubmission.title);
    expect(dialog.message, contains('envoyer votre demande de réservation'));
    expect(dialog.message.toLowerCase(), isNot(contains('mal passé')));
  });

  test('« Réessayer » seulement si récupérable ET retry fourni', () async {
    coordinator.present(
      error: const ServerError(),
      context: ErrorContext.paymentInitiation,
    );
    expect(presenter.dialogs.last.actionLabel, isNull);
    await pumpEventQueue(); // dialogue précédent fermé

    now = now.add(const Duration(minutes: 1));
    coordinator.present(
      error: const ServerError(),
      context: ErrorContext.paymentInitiation,
      retry: () {},
    );
    expect(presenter.dialogs.last.actionLabel, 'Réessayer');
  });

  test('erreur métier non récupérable : pas de « Réessayer »', () {
    coordinator.present(
      error: const BusinessError(code: 'PAYMENT_DECLINED', message: 'Refusé.'),
      context: ErrorContext.paymentInitiation,
      retry: () {},
    );
    final dialog = presenter.dialogs.single;
    expect(dialog.message, 'Refusé.');
    expect(dialog.actionLabel, isNull);
  });

  test('déduplication : même erreur dans la fenêtre → un seul retour',
      () async {
    for (var i = 0; i < 3; i++) {
      coordinator.present(
        error: const BusinessError(code: 'X', message: 'm'),
        context: ErrorContext.generic,
      );
    }
    expect(presenter.dialogs, hasLength(1));
    await pumpEventQueue();

    now = now.add(ErrorFeedbackCoordinator.dedupeWindow);
    coordinator.present(
      error: const BusinessError(code: 'X', message: 'm'),
      context: ErrorContext.generic,
    );
    expect(presenter.dialogs, hasLength(2));
  });

  test('perte de connexion : un seul dialogue tant qu\'il est ouvert',
      () async {
    coordinator.present(
        error: const NetworkError(), context: ErrorContext.generic);
    now = now.add(const Duration(minutes: 1));
    coordinator.present(
        error: const NetworkError(), context: ErrorContext.bookingSubmission);
    expect(presenter.offlineDialogs, 1);
    expect(presenter.dialogs, isEmpty);

    // Retour du réseau : le dialogue est fermé.
    coordinator.onConnectionRestored();
    expect(presenter.hiddenOfflineDialogs, 1);
    await pumpEventQueue();

    now = now.add(const Duration(minutes: 1));
    coordinator.present(
        error: const NetworkError(), context: ErrorContext.generic);
    expect(presenter.offlineDialogs, 2);
  });

  test('perte de connexion : la relance est transmise au presenter', () {
    var relaunched = 0;
    coordinator.present(
      error: const NetworkError(),
      context: ErrorContext.generic,
      retry: () => relaunched++,
    );
    presenter.lastRestored!();
    expect(relaunched, 1);
  });

  test('session expirée : dialogue « Se reconnecter »', () async {
    coordinator.present(
      error: const UnauthorizedError(statusCode: 401),
      context: ErrorContext.generic,
    );
    expect(presenter.dialogs.single.actionLabel, 'Se reconnecter');
    await presenter.lastAction!();
    expect(presenter.signInOpened, 1);
  });

  test('403 : affiche le message métier du back, sans « Se reconnecter »', () {
    coordinator.present(
      error: const ForbiddenError(
        code: 'FORBIDDEN',
        message:
            'Votre type de compte ne vous autorise pas à continuer sur cette page',
      ),
      context: ErrorContext.authentication,
    );
    final dialog = presenter.dialogs.single;
    expect(dialog.title, 'Accès refusé');
    expect(dialog.message, contains('type de compte'));
    expect(dialog.actionLabel, isNull);
  });

  test('validation avec champs : rien en global (affichage inline)', () {
    coordinator.present(
      error: const ValidationError(fieldErrors: {
        'email': ['invalide']
      }),
      context: ErrorContext.authentication,
    );
    expect(presenter.dialogs, isEmpty);
    expect(presenter.toasts, isEmpty);
  });

  test('validation sans champ : toast', () {
    coordinator.present(
      error: const ValidationError(message: 'Vérifiez la date.'),
      context: ErrorContext.bookingSubmission,
    );
    expect(presenter.toasts, hasLength(1));
    expect(presenter.dialogs, isEmpty);
  });

  test('chargement principal : l\'écran porte l\'erreur, pas de dialogue', () {
    coordinator.present(
      error: const ServerError(),
      context: ErrorContext.bookingLoad,
      retry: () {},
    );
    expect(presenter.dialogs, isEmpty);
    expect(presenter.toasts, isEmpty);
  });

  test('presentThrown : false pour une erreur silencieuse ou hors API', () {
    expect(
      coordinator.presentThrown(const ServerError(silent: true),
          context: ErrorContext.generic),
      isFalse,
    );
    expect(
      coordinator.presentThrown(StateError('plugin'),
          context: ErrorContext.generic),
      isFalse,
    );
    expect(presenter.dialogs, isEmpty);

    expect(
      coordinator.presentThrown(const ServerError(),
          context: ErrorContext.generic),
      isTrue,
    );
    expect(presenter.dialogs, hasLength(1));
  });

  test('télémétrie : seules les erreurs inattendues sont remontées', () {
    coordinator.present(
        error: const ServerError(), context: ErrorContext.generic);
    coordinator.present(
        error: const BusinessError(code: 'A', message: 'm'),
        context: ErrorContext.generic);
    expect(crashlytics.recorded, ['ServerError@generic']);
  });
}
