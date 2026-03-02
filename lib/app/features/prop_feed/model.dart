// video_model.dart
class VideoModel {
  final String id;
  final String url;
  /// URL d'une image (poster/thumbnail) affichée immédiatement pendant le chargement de la vidéo.
  final String? thumbnailUrl;

  VideoModel({required this.id, required this.url, this.thumbnailUrl});
}
