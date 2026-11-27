/// Réponse de `POST /public/share-links/{token}/open` (et, sans `sessionId`,
/// de `GET /public/share-links/{token}`).
class ShareLinkOpenModel {
  const ShareLinkOpenModel({
    required this.residenceId,
    this.sessionId,
    this.redirectUrl,
  });

  final String residenceId;

  /// Session de partage : sert à rattacher les événements suivants au lien.
  final String? sessionId;
  final String? redirectUrl;

  factory ShareLinkOpenModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;
    return ShareLinkOpenModel(
      residenceId: data['residenceId']?.toString() ?? '',
      sessionId: data['sessionId']?.toString(),
      redirectUrl: data['redirectUrl']?.toString(),
    );
  }
}
