enum AdType {
  image("IMAGE"),
  video("VIDEO"),
  carousel("CAROUSEL");

  final String value;
  const AdType(this.value);

  static AdType? fromString(String? value) {
    if (value == null) return null;
    return AdType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AdType.image,
    );
  }
}
