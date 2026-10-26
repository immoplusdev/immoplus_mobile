import 'dart:async';

/// Sérialise les demandes de permission système.
///
/// Android/iOS n'acceptent qu'une seule demande à la fois : une seconde
/// demande lancée pendant qu'une pop-up est affichée échoue aussitôt (ex :
/// localisation de l'accueil pendant l'activation des notifications).
/// Chaque demande attend la fin de la précédente.
class PermissionRequestQueue {
  PermissionRequestQueue._();

  static Future<void> _tail = Future.value();

  static Future<T> run<T>(Future<T> Function() request) {
    final completer = Completer<T>();
    _tail = _tail.then((_) async {
      try {
        completer.complete(await request());
      } catch (e, stack) {
        completer.completeError(e, stack);
      }
    });
    return completer.future;
  }
}
