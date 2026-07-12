enum TransactionType {
  acheter("acheter"),
  louer("louer");

  final String value;
  const TransactionType(this.value);

  static TransactionType fromString(String? value) {
    return TransactionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TransactionType.acheter,
    );
  }
}
