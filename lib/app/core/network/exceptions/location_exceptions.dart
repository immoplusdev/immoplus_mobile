/// Exception de base pour toutes les erreurs de localisation
abstract class LocationException implements Exception {
  final String message;
  final String? details;

  const LocationException(this.message, [this.details]);

  @override
  String toString() => details != null ? '$message: $details' : message;
}

/// Exception levée quand les services de localisation sont désactivés
class CustomLocationServiceDisabledException extends LocationException {
  const CustomLocationServiceDisabledException([String? details])
      : super(
          'Les services de localisation sont désactivés',
          details,
        );
}

/// Exception levée quand la permission de localisation est refusée
class LocationPermissionDeniedException extends LocationException {
  const LocationPermissionDeniedException([String? details])
      : super(
          'Activez votre localisation pour accéder à cette section',
          details,
        );
}

/// Exception levée quand la permission est refusée définitivement
class LocationPermissionDeniedForeverException extends LocationException {
  const LocationPermissionDeniedForeverException([String? details])
      : super(
          'Permission de localisation refusée définitivement, Activez votre localisation pour accéder à cette section',
          details,
        );
}

/// Exception levée quand la récupération de la position timeout
class LocationTimeoutException extends LocationException {
  const LocationTimeoutException([String? details])
      : super(
          'Délai d\'attente dépassé pour obtenir la position',
          details,
        );
}

/// Exception levée pour toute autre erreur de localisation
class LocationUnknownException extends LocationException {
  const LocationUnknownException([String? details])
      : super(
          'Activez votre localisation pour accéder à cette section',
          details,
        );
}
