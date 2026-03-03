/// Sous-modèles du feed API
class FeedItemContent {
  const FeedItemContent({
    this.title,
    this.description,
    this.price,
    this.location,
  });

  final String? title;
  final String? description;
  final String? price;
  final String? location;

  factory FeedItemContent.fromJson(Map<String, dynamic> json) =>
      FeedItemContent(
        title: json['title'] as String?,
        description: json['description'] as String?,
        price: json['price'] as String?,
        location: json['location'] as String?,
      );
}

class FeedItemStats {
  const FeedItemStats({this.likes = 0, this.views = 0});

  final int likes;
  final int views;

  factory FeedItemStats.fromJson(Map<String, dynamic> json) => FeedItemStats(
        likes: json['likes'] as int? ?? 0,
        views: json['views'] as int? ?? 0,
      );
}

class FeedItemAuthor {
  const FeedItemAuthor({this.id, this.name, this.avatar});

  final String? id;
  final String? name;
  final String? avatar;

  factory FeedItemAuthor.fromJson(Map<String, dynamic> json) => FeedItemAuthor(
        id: json['id'] as String?,
        name: json['name'] as String?,
        avatar: json['avatar'] as String?,
      );
}

class FeedItemRelatedTo {
  const FeedItemRelatedTo({this.entity, this.id});

  final String? entity;
  final String? id;

  factory FeedItemRelatedTo.fromJson(Map<String, dynamic> json) =>
      FeedItemRelatedTo(
        entity: json['entity'] as String?,
        id: json['id'] as String?,
      );
}

/// Modèle d'une vidéo du feed.
/// Compatible avec la réponse GET /feed et GET /feed/videos/:id.
class VideoModel {
  const VideoModel({
    required this.id,
    required this.url,
    this.thumbnailUrl,
    this.source,
    this.status = 'ready',
    this.content,
    this.stats,
    this.relatedTo,
    this.author,
    this.createdAt,
  });

  final String id;

  /// URL de la vidéo (champ videoUrl dans l'API).
  final String url;

  final String? thumbnailUrl;
  final String? source;
  final String status;
  final FeedItemContent? content;
  final FeedItemStats? stats;
  final FeedItemRelatedTo? relatedTo;
  final FeedItemAuthor? author;
  final String? createdAt;

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        id: json['id'] as String? ?? '',
        url: json['videoUrl'] as String? ?? '',
        thumbnailUrl: json['thumbnailUrl'] as String?,
        source: json['source'] as String?,
        status: json['status'] as String? ?? 'ready',
        content: json['content'] != null
            ? FeedItemContent.fromJson(
                json['content'] as Map<String, dynamic>)
            : null,
        stats: json['stats'] != null
            ? FeedItemStats.fromJson(json['stats'] as Map<String, dynamic>)
            : null,
        relatedTo: json['relatedTo'] != null
            ? FeedItemRelatedTo.fromJson(
                json['relatedTo'] as Map<String, dynamic>)
            : null,
        author: json['author'] != null
            ? FeedItemAuthor.fromJson(json['author'] as Map<String, dynamic>)
            : null,
        createdAt: json['createdAt'] as String?,
      );
}
