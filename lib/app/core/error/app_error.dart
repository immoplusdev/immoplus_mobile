/// Erreur applicative typée, construite à partir du contrat d'erreur de l'API
/// (voir `AppErrorMapper`). Les features et l'UI ne manipulent jamais de
/// `DioException` brute : elles reçoivent un [AppError].
///
/// [message] est une formulation métier sûre à afficher (jamais de détail
/// technique). [cause] et [requestId] servent uniquement aux logs et au
/// support.
sealed class AppError implements Exception {
  const AppError({
    this.message,
    this.code,
    this.requestId,
    this.statusCode,
    this.retryable = false,
    this.silent = false,
    this.cause,
  });

  /// Message métier sûr, fourni par l'API (peut être nul).
  final String? message;

  /// Code métier normalisé (ex: `RESERVATION_ALREADY_ACTIVE`).
  final String? code;

  /// Identifiant de corrélation avec les logs serveur.
  final String? requestId;

  final int? statusCode;

  /// L'opération peut être relancée sans effet de bord.
  final bool retryable;

  /// Requête de fond : ne doit jamais déclencher de feedback utilisateur.
  final bool silent;

  /// Erreur technique d'origine, pour la télémétrie uniquement.
  final Object? cause;

  @override
  String toString() =>
      '$runtimeType(code: $code, status: $statusCode, requestId: $requestId)';
}

/// Pas de connexion, délai dépassé, serveur injoignable.
final class NetworkError extends AppError {
  const NetworkError({super.cause, super.silent})
      : super(retryable: true, message: null);
}

/// Session absente ou expirée (401) : il faut se reconnecter.
final class UnauthorizedError extends AppError {
  const UnauthorizedError({
    super.message,
    super.code,
    super.requestId,
    super.statusCode,
    super.silent,
    super.cause,
  });
}

/// Accès refusé alors que la session est valide (403) : ex. type de compte
/// non autorisé. Le message métier du back est affiché tel quel.
final class ForbiddenError extends AppError {
  const ForbiddenError({
    super.message,
    super.code,
    super.requestId,
    super.statusCode = 403,
    super.silent,
    super.cause,
  });
}

/// Données invalides ; [fieldErrors] porte les erreurs par champ.
final class ValidationError extends AppError {
  const ValidationError({
    this.fieldErrors = const {},
    super.message,
    super.code,
    super.requestId,
    super.statusCode,
    super.silent,
    super.cause,
  });

  /// Nom du champ → messages.
  final Map<String, List<String>> fieldErrors;

  bool get hasFieldErrors => fieldErrors.isNotEmpty;

  /// Premier message du champ, pour l'afficher sous un `TextFormField`.
  String? fieldError(String field) {
    final messages = fieldErrors[field];
    return messages == null || messages.isEmpty ? null : messages.first;
  }
}

/// Règle métier refusée (ex: `PAYMENT_DECLINED`).
final class BusinessError extends AppError {
  const BusinessError({
    super.message,
    super.code,
    super.requestId,
    super.statusCode,
    super.retryable,
    super.silent,
    super.cause,
  });
}

/// Ressource introuvable (404).
final class NotFoundError extends AppError {
  const NotFoundError({
    super.message,
    super.code,
    super.requestId,
    super.statusCode,
    super.silent,
    super.cause,
  });
}

/// Erreur serveur (5xx). Le message serveur n'est jamais affiché.
final class ServerError extends AppError {
  const ServerError({
    super.code,
    super.requestId,
    super.statusCode,
    super.retryable = true,
    super.silent,
    super.cause,
  }) : super(message: null);
}

/// Erreur inattendue (hors contrat).
final class UnknownError extends AppError {
  const UnknownError({
    super.code,
    super.requestId,
    super.statusCode,
    super.silent,
    super.cause,
  }) : super(message: null);
}
