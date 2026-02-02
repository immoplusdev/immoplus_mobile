enum ApiErrorCode {
  // Erreurs d'authentification
  unauthorized('UNAUTHORIZED'),
  authenticationFailed('AUTHENTICATION_FAILED'),
  invalidPassword('INVALID_PASSWORD'),
  wrongPassword('WRONG_PASSWORD'),

  // Erreurs de token JWT
  jwtTokenExpired('JWT_TOKEN_EXPIRED'),
  jwtTokenInvalid('JWT_TOKEN_INVALID'),
  jwtTokenNotActive('JWT_TOKEN_NOT_ACTIVE'),
  jwtTokenMissing('JWT_TOKEN_MISSING'),
  invalidRefreshToken('INVALID_REFRESH_TOKEN'),
  socialAccountNotFound('SOCIAL_ACCOUNT_NOT_FOUND'),

  // Erreurs de permissions
  insufficientPermissions('INSUFFICIENT_PERMISSIONS'),

  // Erreurs de validation
  invalidOtp('INVALID_OTP'),

  // Erreur inconnue
  unknown('UNKNOWN');

  const ApiErrorCode(this.value);

  final String value;

  /// Crée un enum à partir d'un string
  static ApiErrorCode fromString(String? code) {
    return ApiErrorCode.values.firstWhere(
      (e) => e.value == code,
      orElse: () => ApiErrorCode.unknown,
    );
  }

  /// Vérifie si l'erreur est liée à l'authentification
  bool get isAuthRelated {
    switch (this) {
      case ApiErrorCode.unauthorized:
      case ApiErrorCode.authenticationFailed:
      case ApiErrorCode.invalidPassword:
      case ApiErrorCode.wrongPassword:
      case ApiErrorCode.jwtTokenExpired:
      case ApiErrorCode.jwtTokenInvalid:
      case ApiErrorCode.jwtTokenNotActive:
      case ApiErrorCode.jwtTokenMissing:
      case ApiErrorCode.invalidRefreshToken:
        return true;
      default:
        return false;
    }
  }

  /// Vérifie si l'erreur nécessite une déconnexion complète
  bool get requiresLogout {
    switch (this) {
      case ApiErrorCode.invalidRefreshToken:
        return true;
      default:
        return false;
    }
  }
}
