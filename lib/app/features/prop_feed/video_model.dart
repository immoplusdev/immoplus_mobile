/// Sous-modèles du feed API
class FeedItemContent {
  const FeedItemContent({
    this.title,
    this.description,
    this.price,
    this.location,
    this.commodites = const [],
    this.pieces = const [],
  });

  final String? title;
  final String? description;
  final String? price;
  final String? location;

  /// [{ "text": "WiFi", "icon": "wifi" }, ...]
  final List<FeedCommodite> commodites;

  /// [{ "nom": "Chambre", "nombre": 1 }, ...]
  final List<FeedPiece> pieces;

  factory FeedItemContent.fromJson(Map<String, dynamic> json) {
    final commoditesRaw = json['commodites'] as List<dynamic>? ?? [];
    final piecesRaw = json['pieces'] as List<dynamic>? ?? [];
    return FeedItemContent(
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: json['price'] as String?,
      location: json['location'] as String?,
      commodites: commoditesRaw
          .map((e) => FeedCommodite.fromJson(e as Map<String, dynamic>))
          .toList(),
      pieces: piecesRaw
          .map((e) => FeedPiece.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FeedCommodite {
  const FeedCommodite({required this.text, required this.icon});
  final String text;
  final String icon;
  factory FeedCommodite.fromJson(Map<String, dynamic> json) => FeedCommodite(
        text: json['text'] as String? ?? '',
        icon: json['icon'] as String? ?? '',
      );
}

class FeedPiece {
  const FeedPiece({
    required this.nom,
    required this.nombre,
    this.value,
  });
  final String nom;
  final int nombre;
  final String? value;
  factory FeedPiece.fromJson(Map<String, dynamic> json) => FeedPiece(
        nom: json['nom'] as String? ?? '',
        nombre: json['nombre'] as int? ?? 0,
        value: json['value'] as String?,
      );
}

class FeedItemStats {
  const FeedItemStats({this.likes = 0, this.views = 0, this.liked = false});

  final int likes;
  final int views;
  final bool liked;

  factory FeedItemStats.fromJson(Map<String, dynamic> json) => FeedItemStats(
        likes: json['likes'] as int? ?? 0,
        views: json['views'] as int? ?? 0,
        liked: json['liked'] as bool? ?? false,
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

    /// UUID du fichier miniature (table files). URL: {baseUrl}/files/raw/public/{miniature}
    this.miniature,
    this.source,
    this.status = 'ready',
    this.content,
    this.stats,
    this.relatedTo,
    this.author,
    this.createdAt,
    this.shortCode,
    this.videoType,
    this.availableBitrates = const <int>[],
    this.bitrateUrls = const <int, String>{},
  });

  final String id;

  /// URL de la vidéo (champ videoUrl dans l'API).
  /// Pour une vidéo HLS, c'est le master playlist (`master.m3u8`).
  final String url;

  final String? thumbnailUrl;
  final String? miniature;
  final String? source;
  final String status;
  final FeedItemContent? content;
  final FeedItemStats? stats;
  final FeedItemRelatedTo? relatedTo;
  final FeedItemAuthor? author;
  final String? createdAt;

  /// Code court pour le partage (ex: "Xk9mP2"). Fourni par GET /feed.
  final String? shortCode;

  /// `hls` quand le backend a produit un ladder adaptatif, `mp4` sinon (legacy).
  final String? videoType;

  /// Paliers de qualité disponibles, croissants (ex: `[360, 720]`).
  final List<int> availableBitrates;

  /// Playlist de chaque palier : `{360: 'https://…/360p/playlist.m3u8'}`.
  final Map<int, String> bitrateUrls;

  bool get isHls => videoType == 'hls' || url.contains('.m3u8');

  String get playbackUrl {
    if (availableBitrates.length == 1) {
      final direct = bitrateUrls[availableBitrates.first];
      if (direct != null && direct.isNotEmpty) return direct;
    }
    return url;
  }

  static List<int> _parseBitrates(dynamic raw) {
    if (raw is! List) return const <int>[];
    final parsed = raw
        .map((e) => e is int ? e : int.tryParse('$e'))
        .whereType<int>()
        .toList()
      ..sort();
    return parsed;
  }

  /// Les clés JSON sont des chaînes (`{"360": "..."}`) — TypeScript sérialise
  /// `Record<number, string>` ainsi.
  static Map<int, String> _parseBitrateUrls(dynamic raw) {
    if (raw is! Map) return const <int, String>{};
    final parsed = <int, String>{};
    raw.forEach((key, value) {
      final bitrate = key is int ? key : int.tryParse('$key');
      if (bitrate != null && value is String && value.isNotEmpty) {
        parsed[bitrate] = value;
      }
    });
    return parsed;
  }

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        id: json['id'] as String? ?? '',
        url: json['videoUrl'] as String? ?? '',
        thumbnailUrl: json['thumbnailUrl'] as String?,
        miniature: json['miniature'] as String?,
        source: json['source'] as String?,
        status: json['status'] as String? ?? 'ready',
        content: json['content'] != null
            ? FeedItemContent.fromJson(json['content'] as Map<String, dynamic>)
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
        shortCode: json['shortCode'] as String?,
        videoType: json['videoType'] as String?,
        availableBitrates: _parseBitrates(json['availableBitrates']),
        bitrateUrls: _parseBitrateUrls(json['bitrateUrls']),
      );
}
