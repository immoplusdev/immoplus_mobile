/// Représente le payload d'un `alert_clarification` (spec §5.2).
class ChatClarification {
  const ChatClarification({
    required this.askedField,
    this.partialCriteria = const {},
    this.missingFields = const [],
    this.origin,
  });

  /// Champ demandé par l'IA : `transaction_type`, `property_type`,
  /// `rooms_min`, `price_max`, `location`, `extras`, `surface_min`.
  final String? askedField;

  /// Critères déjà compris par l'IA — affichés en chips non interactifs.
  final Map<String, dynamic> partialCriteria;

  /// Liste des champs encore manquants (info, pas utilisé par l'UI pour
  /// l'instant mais peut servir à afficher un compteur "3e/3").
  final List<String> missingFields;

  /// `origin`: raw / computed. Non utilisé pour l'instant.
  final String? origin;

  bool get hasAskedField =>
      askedField != null && askedField!.trim().isNotEmpty;

  /// Résumé des critères compris, en chips courts.
  List<String> get partialChips {
    final c = partialCriteria;
    final out = <String>[];

    final tx = _str(c['transactionType'] ?? c['transaction_type']);
    if (tx != null) out.add(_labelTransaction(tx));

    final pt = _str(c['propertyType'] ?? c['property_type']);
    if (pt != null) out.add(_labelProperty(pt));

    final loc =
        _str(c['location']) ?? _str(c['commune']) ?? _str(c['quartier']);
    if (loc != null) out.add(loc);

    final rooms = c['roomsMin'] ?? c['rooms_min'] ?? c['rooms'];
    if (rooms is num) out.add('${rooms.round()}p+');

    final priceMax = c['priceMax'] ?? c['price_max'];
    if (priceMax is num) out.add('max ${_priceShort(priceMax)}');

    final surface = c['surfaceMin'] ?? c['surface_min'];
    if (surface is num) out.add('${surface.round()} m²+');

    return out;
  }

  static ChatClarification fromData(Map<String, dynamic>? data) {
    if (data == null) return const ChatClarification(askedField: null);

    final partial = data['partialCriteria'] ?? data['partial_criteria'];
    final missing = data['missingFields'] ?? data['missing_fields'];

    return ChatClarification(
      askedField: _str(data['askedField'] ?? data['asked_field']),
      partialCriteria:
          partial is Map ? Map<String, dynamic>.from(partial) : const {},
      missingFields: missing is List
          ? missing.map((e) => e.toString()).toList(growable: false)
          : const [],
      origin: _str(data['origin']),
    );
  }

  static String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  static String _labelTransaction(String raw) {
    switch (raw.toLowerCase()) {
      case 'buy':
      case 'acheter':
      case 'achat':
        return 'Achat';
      case 'rent':
      case 'louer':
      case 'location':
        return 'Location';
      case 'reservation':
      case 'reserver':
      case 'réserver':
        return 'Réservation';
      default:
        return raw;
    }
  }

  static String _labelProperty(String raw) {
    switch (raw.toLowerCase()) {
      case 'apartment':
      case 'appart':
      case 'appartement':
        return 'Appart';
      case 'villa':
        return 'Villa';
      case 'studio':
        return 'Studio';
      case 'office':
      case 'bureau':
        return 'Bureau';
      case 'land':
      case 'terrain':
        return 'Terrain';
      default:
        return raw;
    }
  }

  static String _priceShort(num value) {
    if (value >= 1000000) {
      final m = value / 1000000;
      final s = m.toStringAsFixed(m % 1 == 0 ? 0 : 1).replaceAll('.', ',');
      return '${s}M';
    }
    if (value >= 1000) return '${(value / 1000).round()}k';
    return value.toString();
  }
}
