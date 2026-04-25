import 'chat_property.dart';

/// Représente la data renvoyée par `alert_created` / `alert_updated` /
/// `show_results`. Parse tolérant : les champs peuvent être absents.
class ChatAlertPayload {
  const ChatAlertPayload({
    this.alertId,
    this.criteria = const {},
    this.matches = const [],
    this.totalMatches,
    this.message,
  });

  final String? alertId;
  final Map<String, dynamic> criteria;
  final List<ChatProperty> matches;
  final int? totalMatches;
  final String? message;

  bool get hasMatches => matches.isNotEmpty;

  /// Récap critères en chips courts (ordre stable).
  List<String> get criteriaChips {
    final c = criteria;
    final out = <String>[];

    final tx = _str(c['transactionType'] ?? c['transaction_type']);
    if (tx != null) out.add(_labelTransaction(tx));

    final pt = _str(c['propertyType'] ?? c['property_type']);
    if (pt != null) out.add(_labelProperty(pt));

    final loc = _str(c['location']) ?? _str(c['commune']) ?? _str(c['quartier']);
    if (loc != null) out.add(loc);

    final rooms = c['roomsMin'] ?? c['rooms_min'] ?? c['rooms'];
    if (rooms is num) {
      out.add('${rooms.round()}p+');
    } else if (rooms is String && rooms.isNotEmpty) {
      out.add('${rooms}p+');
    }

    final priceMax = c['priceMax'] ?? c['price_max'];
    if (priceMax is num) out.add('max ${_formatPriceShort(priceMax)}');

    final surfaceMin = c['surfaceMin'] ?? c['surface_min'];
    if (surfaceMin is num) out.add('${surfaceMin.round()} m²+');

    return out;
  }

  static ChatAlertPayload fromData(Map<String, dynamic>? data) {
    if (data == null) return const ChatAlertPayload();

    final crit = data['criteria'];
    final matchesRaw =
        data['immediateMatches'] ?? data['matches'] ?? data['biens'];

    return ChatAlertPayload(
      alertId: _str(data['alertId']) ?? _str(data['id']),
      criteria: crit is Map ? Map<String, dynamic>.from(crit) : const {},
      matches: ChatProperty.parseList(matchesRaw),
      totalMatches: _int(data['totalMatches']) ?? _int(data['total']),
      message: _str(data['message']),
    );
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

  static String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  static int? _int(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.round();
    if (v is String) return int.tryParse(v);
    return null;
  }
}

/// Format court pour les prix XOF : `500k`, `1,2M`, sinon valeur brute.
String _formatPriceShort(num value) {
  final v = value.abs();
  if (v >= 1000000) {
    final m = value / 1000000;
    final s = m.toStringAsFixed(m % 1 == 0 ? 0 : 1).replaceAll('.', ',');
    return '${s}M';
  }
  if (v >= 1000) {
    return '${(value / 1000).round()}k';
  }
  return value.toString();
}

/// Format long pour les prix XOF : `480 000 F`.
String formatPriceLong(num value) {
  final v = value.round();
  final s = v.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
    buf.write(s[i]);
  }
  return '${buf.toString()} F';
}
