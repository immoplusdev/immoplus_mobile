class RelaisModuleStatusResponse {
  final bool active;

  const RelaisModuleStatusResponse({required this.active});

  factory RelaisModuleStatusResponse.fromJson(Map<String, dynamic> json) {
    return RelaisModuleStatusResponse(active: json['active'] as bool? ?? false);
  }

  Map<String, dynamic> toJson() => {'active': active};
}
