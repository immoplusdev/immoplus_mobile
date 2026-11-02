import 'package:immoplus/app/core/error/app_error.dart';
import 'package:immoplus/app/core/error/app_error_mapper.dart';
import 'package:immoplus/app/core/error/error_context.dart';

/// Texte affichable d'une erreur : titre clair + explication orientée action.
class ErrorText {
  const ErrorText({required this.title, required this.message});

  final String title;
  final String message;
}

/// Seul endroit qui produit les textes d'erreur : le dialogue, les toasts et
/// les états d'erreur inline restent ainsi cohérents. Aucun détail technique
/// n'est jamais exposé ; le message serveur n'est repris que lorsqu'il est
/// une formulation métier sûre (erreurs 4xx).
class ErrorMessages {
  const ErrorMessages._();

  /// Message lisible pour une exception quelconque (états d'erreur inline
  /// des cubits) : jamais de `toString()` technique dans l'UI.
  static String messageOf(Object error, ErrorContext context) =>
      describe(AppErrorMapper.from(error), context).message;

  static ErrorText describe(AppError error, ErrorContext context) {
    return switch (error) {
      NetworkError() => const ErrorText(
          title: 'Pas de connexion',
          message: 'Vérifiez votre connexion internet puis réessayez.',
        ),
      UnauthorizedError() => const ErrorText(
          title: 'Session expirée',
          message: 'Votre session a expiré. Reconnectez-vous pour continuer.',
        ),
      ForbiddenError(:final message) => ErrorText(
          title: 'Accès refusé',
          message: message ?? "Vous n'avez pas accès à cette ressource.",
        ),
      NotFoundError(:final message) => ErrorText(
          title: 'Introuvable',
          message: message ?? "Ce contenu n'existe plus ou a été retiré.",
        ),
      ValidationError(:final message) => ErrorText(
          title: 'Informations invalides',
          message: message ?? 'Vérifiez les informations saisies.',
        ),
      BusinessError(:final message) => ErrorText(
          title: context.title,
          message: message ?? "Nous n'avons pas pu ${context.action}.",
        ),
      ServerError() => ErrorText(
          title: context.title,
          message: 'Notre service rencontre un problème pour '
              '${context.action}. Réessayez dans quelques instants.',
        ),
      UnknownError() => ErrorText(
          title: context.title,
          message: "Nous n'avons pas pu ${context.action}. Réessayez dans "
              'quelques instants. Si le problème continue, contactez le '
              'support.',
        ),
    };
  }
}
