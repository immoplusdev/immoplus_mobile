enum ContactChangeType {
  phone("phone"),
  email("email");

  final String value;

  const ContactChangeType(this.value);

  static ContactChangeType fromString(String status) {
    return ContactChangeType.values.firstWhere(
      (e) => e.value == status,
      orElse: () => throw ArgumentError('Unknown ContactChangeType: $status'),
    );
  }

  String get toJson => value;
}
