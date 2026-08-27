class HotelModuleStatusResponse {
  final bool active;

  const HotelModuleStatusResponse({required this.active});

  factory HotelModuleStatusResponse.fromJson(Map<String, dynamic> json) {
    return HotelModuleStatusResponse(active: json['active'] as bool? ?? false);
  }
}
