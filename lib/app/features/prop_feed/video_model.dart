/// Modèle d'une vidéo du feed.
class VideoModel {
  const VideoModel({
    required this.id,
    required this.url,
    this.thumbnailUrl,
  });

  final String id;
  final String url;
  /// URL d'une image (poster/thumbnail) affichée pendant le chargement.
  final String? thumbnailUrl;
}
