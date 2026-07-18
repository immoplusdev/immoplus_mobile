/// Modèle léger représentant un bien dans une réponse du chat IA.
///
/// Parse de façon tolérante les payloads du backend (`immediateMatches`,
/// `matches`, `sources`) : les noms de champs varient selon l'intent.
class ChatProperty {
  const ChatProperty({
    required this.id,
    required this.title,
    this.imageUrl,
    this.location,
    this.price,
    this.rooms,
    this.surface,
    this.score,
    this.excerpt,
    this.entityType,
  });

  final String id;
  final String title;
  final String? imageUrl;
  final String? location;
  final num? price;
  final int? rooms;
  final num? surface;

  /// Score de pertinence 0..1 (RAG) ou 0..100 (matches).
  final double? score;

  /// Extrait textuel (pour les sources RAG).
  final String? excerpt;

  /// Type d'entité : 'BIEN_IMMOBILIER', 'RESIDENCE', 'FURNITURE'.
  final String? entityType;

  /// Score normalisé 0..100.
  int? get scorePercent {
    final s = score;
    if (s == null) return null;
    final pct = s > 1 ? s : s * 100;
    return pct.clamp(0, 100).round();
  }

  static ChatProperty? tryParse(dynamic raw) {
    if (raw is! Map) return null;
    final m = Map<String, dynamic>.from(raw);

    final id = _str(m['id']) ?? _str(m['bienId']) ?? _str(m['propertyId']);
    if (id == null || id.isEmpty) return null;

    final title = _str(m['title']) ??
        _str(m['name']) ??
        _str(m['libelle']) ??
        _str(m['nom']) ??
        'Bien';

    return ChatProperty(
      id: id,
      title: title,
      imageUrl: _firstImage(m),
      location: _str(m['location']) ??
          _str(m['commune']) ??
          _str(m['quartier']) ??
          _str(m['adresse']),
      price: _num(m['price']) ??
          _num(m['prix']) ??
          _num(m['loyer']) ??
          _num(m['prixReservation']),
      rooms: _int(m['rooms']) ?? _int(m['nbPieces']) ?? _int(m['pieces']),
      surface: _num(m['surface']) ?? _num(m['superficie']) ?? _num(m['area']),
      score: _double(m['score']) ?? _double(m['pertinence']),
      excerpt: _str(m['excerpt']) ?? _str(m['extrait']),
      entityType: _str(m['entityType']),
    );
  }

  static List<ChatProperty> parseList(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .map(ChatProperty.tryParse)
        .whereType<ChatProperty>()
        .toList(growable: false);
  }

  static String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  static num? _num(dynamic v) {
    if (v is num) return v;
    if (v is String) return num.tryParse(v);
    return null;
  }

  static int? _int(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.round();
    if (v is String) return int.tryParse(v);
    return null;
  }

  static double? _double(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  static String? _firstImage(Map<String, dynamic> m) {
    final candidates = [
      m['imageUrl'],
      m['image'],
      m['thumbnail'],
      m['photo'],
      m['cover'],
    ];
    for (final c in candidates) {
      final s = _str(c);
      if (s != null) return s;
    }
    final photos = m['photos'] ?? m['images'] ?? m['medias'];
    if (photos is List && photos.isNotEmpty) {
      final first = photos.first;
      if (first is String) return _str(first);
      if (first is Map) {
        return _str(first['url']) ?? _str(first['src']) ?? _str(first['path']);
      }
    }
    return null;
  }
}
