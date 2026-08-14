enum AdType {
  image('IMAGE'),
  video('VIDEO'),
  carousel('CAROUSEL'),
  videoCarousel('VIDEO_CAROUSEL');

  final String value;
  const AdType(this.value);

  static AdType fromString(String? value) {
    if (value == null) return AdType.image;
    return AdType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AdType.image,
    );
  }
}
