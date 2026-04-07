enum ValidationStatus {
  valide("valide"),
  rejete("rejete"),
  enValidation("en_validation");

  final String value;

  const ValidationStatus(this.value);

  static ValidationStatus fromString(String status) {
    switch (status) {
      case 'valide':
        return ValidationStatus.valide;
      case 'rejete':
        return ValidationStatus.rejete;
      default:
        return ValidationStatus.enValidation;
    }
  }

  String get displayName {
    switch (this) {
      case ValidationStatus.valide:
        return 'Validé';
      case ValidationStatus.rejete:
        return 'Rejeté';
      case ValidationStatus.enValidation:
        return 'En validation';
    }
  }
}
