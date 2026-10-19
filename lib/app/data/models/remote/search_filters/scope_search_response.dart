import 'package:immoplus/app/data/models/remote/home_feed/property_badge_dto.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';

/// Réponse paginée de `GET /me/rent`, `GET /me/buy` ou `GET /me/stay`.
///
/// Ce modèle est volontairement léger : il est utilisé uniquement par le flux
/// scopé et ne dépend pas de fichiers générés, afin que l'écran puisse être
/// compilé sans lancer le générateur de code.
class ScopeSearchResponse {
  const ScopeSearchResponse({
    this.data = const [],
    this.totalCount = 0,
    this.hasMore = false,
    this.nextCursor,
  });

  final List<ScopeSearchItem> data;
  final int totalCount;
  final bool hasMore;
  final String? nextCursor;

  factory ScopeSearchResponse.fromJson(Map<String, dynamic> json) {
    final root = json['data'];
    final data =
        root is Map ? Map<String, dynamic>.from(root) : <String, dynamic>{};
    final sections = data['sections'];
    final entries = <Map<String, dynamic>>[];
    var totalCount = 0;
    if (sections is List) {
      for (final rawSection in sections.whereType<Map>()) {
        final section = Map<String, dynamic>.from(rawSection);
        totalCount += _asInt(section['totalCount']);
        final sectionTitle = _firstValue([section['title']]);
        final sectionKey = _firstValue([section['key']]);

        // Une campagne peut être fournie comme section dédiée (`ad_banner`)
        // ou comme élément intercalé dans une section de résultats.
        final sectionAd = section['ad'];
        if (sectionAd is Map) {
          entries.add({
            'itemType': 'ad',
            'ad': Map<String, dynamic>.from(sectionAd),
            'sectionTitle': sectionTitle,
            'sectionKey': sectionKey,
          });
        }
        final items = section['items'];
        if (items is List) {
          entries.addAll(items.whereType<Map>().map((rawItem) {
            final entry = Map<String, dynamic>.from(rawItem);
            // Les cartes sont rendues dans une liste plate, mais elles doivent
            // garder leur section d'origine pour que son titre reste visible.
            entry['sectionTitle'] = sectionTitle;
            entry['sectionKey'] = sectionKey;
            return entry;
          }));
        }
      }
    }
    return ScopeSearchResponse(
      data: entries.map(ScopeSearchItem.fromJson).toList(growable: false),
      totalCount: totalCount,
      hasMore: data['hasMore'] == true,
      nextCursor: _firstValue([data['nextCursor']]),
    );
  }
}

/// Un élément de la liste de résultats à afficher dans une carte.
class ScopeSearchItem {
  const ScopeSearchItem({
    required this.bienId,
    required this.name,
    this.ad,
    this.location,
    this.imageUrl,
    this.price,
    this.currency,
    this.typeBienImmobilier,
    this.aLouer = false,
    this.typeLocation,
    this.description,
    this.chips = const [],
    this.badge,
    this.bedrooms,
    this.distanceKm,
    this.sectionTitle,
    this.sectionKey,
  });

  final String bienId;
  final String name;
  final AdCampaignModel? ad;
  final String? location;
  final String? imageUrl;
  final int? price;
  final String? currency;
  final String? typeBienImmobilier;
  final bool aLouer;
  final String? typeLocation;
  final String? description;
  final List<String> chips;
  final PropertyBadgeDto? badge;
  final int? bedrooms;
  final double? distanceKm;
  final String? sectionTitle;
  final String? sectionKey;

  bool get isAd => ad != null;

  factory ScopeSearchItem.fromJson(Map<String, dynamic> json) {
    final rawAd = json['ad'];
    if (json['itemType'] == 'ad' && rawAd is Map) {
      final ad = AdCampaignModel.fromJson(Map<String, dynamic>.from(rawAd));
      return ScopeSearchItem(
        bienId: 'ad_${ad.id}',
        name: ad.content.title ?? '',
        ad: ad,
        sectionTitle: _firstValue([json['sectionTitle']]),
        sectionKey: _firstValue([json['sectionKey']]),
      );
    }

    // Les endpoints scopés renvoient le format léger documenté dans ONG.MD.
    // Pendant la migration, certaines réponses contiennent encore le format
    // historique de /me/home dans `item` (id, nom, images, prix, ...).
    // Normaliser les deux formats ici évite d'afficher des cartes sans photo
    // ni prix selon la provenance du résultat.
    final source = json['item'] is Map
        ? Map<String, dynamic>.from(json['item'] as Map)
        : json;
    final rawBadge = source['badge'];
    final images = _stringList(source['images']);
    final imageUrl = _firstValue([
      source['imageUrl'],
      source['image_url'],
      source['miniatureUrl'],
      source['miniature_url'],
      source['miniatureId'],
      source['miniature_id'],
      source['miniature'],
      if (images.isNotEmpty) images.first,
    ]);
    final price = _firstInt([
      source['price'],
      source['pricePerNight'],
      source['price_per_night'],
      source['prix'],
      source['prixReservation'],
      source['prix_reservation'],
      source['prixParNuit'],
      source['prix_par_nuit'],
      _mapValue(source['tarification'], 'prixParNuit'),
      _mapValue(source['tarification'], 'prix_par_nuit'),
    ]);
    final rawChips = _stringList(source['chips']);
    final fallbackChips = <String>[
      ..._stringList(source['tags']),
      if (_firstValue([source['location'], source['ville'], source['commune']])
              ?.isNotEmpty ??
          false)
        _firstValue([source['location'], source['ville'], source['commune']])!,
    ];

    return ScopeSearchItem(
      bienId: _firstValue([
            source['bienId'],
            source['residenceId'],
            source['propertyId'],
            source['id'],
          ]) ??
          '',
      name: _firstValue([
            source['name'],
            source['nom'],
            source['title'],
            source['titre']
          ]) ??
          '',
      location: _firstValue([
        source['location'],
        source['ville'],
        source['commune'],
        source['adresse']
      ]),
      imageUrl: imageUrl,
      price: price,
      currency: _firstValue([source['currency'], source['devise']]),
      typeBienImmobilier: _firstValue([
        source['typeBienImmobilier'],
        source['type_bien_immobilier'],
        source['typeResidence'],
        source['type'],
      ]),
      aLouer: source['aLouer'] == true || source['a_louer'] == true,
      typeLocation:
          _firstValue([source['typeLocation'], source['type_location']]),
      description: _firstValue([
        source['description'],
        source['descriptionCourte'],
        source['description_courte']
      ]),
      chips: rawChips.isNotEmpty ? rawChips : fallbackChips,
      badge: rawBadge is Map &&
              rawBadge['tier'] != null &&
              rawBadge['label'] != null
          ? PropertyBadgeDto.fromJson(Map<String, dynamic>.from(rawBadge))
          : null,
      bedrooms: _firstInt([
        source['bedrooms'],
        source['nombreChambres'],
        source['nombre_chambres']
      ]),
      distanceKm: _asDouble(source['distanceKm'] ?? source['distance_km']),
      sectionTitle: _firstValue([json['sectionTitle']]),
      sectionKey: _firstValue([json['sectionKey']]),
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) =>
    _asNullableInt(value) ?? fallback;

int? _asNullableInt(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

double? _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '');
}

int? _firstInt(Iterable<dynamic> values) {
  for (final value in values) {
    final parsed = _asNullableInt(value);
    if (parsed != null) return parsed;
  }
  return null;
}

String? _firstValue(Iterable<dynamic> values) {
  for (final value in values) {
    if (value is Map) {
      final nested = _firstValue([
        value['url'],
        value['imageUrl'],
        value['image_url'],
        value['id'],
        value['fileId'],
        value['file_id'],
      ]);
      if (nested != null) return nested;
      continue;
    }
    final string = value?.toString().trim();
    if (string != null && string.isNotEmpty && string != 'null') return string;
  }
  return null;
}

List<String> _stringList(dynamic value) {
  if (value is! List) return const [];
  return value
      .map((entry) => _firstValue([entry]))
      .whereType<String>()
      .toList(growable: false);
}

dynamic _mapValue(dynamic value, String key) =>
    value is Map ? value[key] : null;
