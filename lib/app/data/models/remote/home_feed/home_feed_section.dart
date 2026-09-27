import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_list_item.dart';
import 'package:immoplus/app/data/models/remote/polls/poll_model.dart';

part 'home_feed_section.freezed.dart';
part 'home_feed_section.g.dart';

abstract class HomeFeedSectionType {
  static const residenceList = 'residence_list';
  static const bienList = 'bien_list';
  static const bienGroupsByLocation = 'bien_groups_by_location';
  static const adBanner = 'ad_banner';
  static const pollBanner = 'poll_banner';

  /// `section.key` (pas `type`) de la section "Les plus aimées" — un
  /// `residence_list` avec un gabarit dédié (voir HOME FEED AGREGATOR.MD
  /// § "top_rated").
  static const topRatedKey = 'top_rated';
}

/// Une entrée de `sections[]` dans la réponse de `GET /me/home`. La forme
/// exacte de son contenu dépend de `type` (voir HOME FEED AGREGATOR.MD § 4) :
/// `items` est soit une liste plate de résidences/biens (+ pubs interleavées),
/// soit une liste de cartes ville (`bien_groups_by_location`), soit vide
/// (`ad_banner`/`poll_banner`, dont le contenu est alors dans `ad`/`poll`).
///
/// `items` est volontairement typé en JSON brut : freezed/json_serializable
/// ne peuvent pas donner un type statique différent à ce même champ selon la
/// valeur de `type` — les getters ci-dessous font cette distinction à la
/// lecture plutôt qu'à la désérialisation.
@freezed
class HomeFeedSection with _$HomeFeedSection {
  const HomeFeedSection._();

  const factory HomeFeedSection({
    required String key,
    required String title,
    required String type,
    @Default(0) int totalCount,
    @Default(1) int page,
    @Default(10) int limit,
    String? seeMoreEndpoint,
    @Default(<dynamic>[]) List<dynamic> items,
    AdCampaignModel? ad,
    PollModel? poll,
  }) = _HomeFeedSection;

  factory HomeFeedSection.fromJson(Map<String, dynamic> json) =>
      _$HomeFeedSectionFromJson(json);

  /// Section sans rien à afficher — à masquer entièrement côté front
  /// (voir HOME FEED AGREGATOR.MD § 6, cas `residences_commune_commune-
  /// assinie-id` : `totalCount: 0`, `items: []`).
  bool get isEmpty {
    switch (type) {
      case HomeFeedSectionType.adBanner:
        return ad == null;
      case HomeFeedSectionType.pollBanner:
        return poll == null;
      default:
        return totalCount <= 0 || items.isEmpty;
    }
  }

  /// Items d'une section `residence_list`/`bien_list` (carousel plat, item
  /// ou pub interleavée).
  List<HomeFeedListItem> get listItems {
    if (type != HomeFeedSectionType.residenceList &&
        type != HomeFeedSectionType.bienList) {
      return const [];
    }
    return items
        .whereType<Map<String, dynamic>>()
        .map(HomeFeedListItem.fromJson)
        .toList();
  }

  /// Cartes ville d'une section `bien_groups_by_location` (ex:
  /// "Biens à louer par ville" — une seule section, plusieurs cartes ville
  /// à l'intérieur, jamais une section par ville).
  List<BienLocationGroup> get locationGroups {
    if (type != HomeFeedSectionType.bienGroupsByLocation) return const [];
    return items
        .whereType<Map<String, dynamic>>()
        .map(BienLocationGroup.fromJson)
        .toList();
  }

  /// "Voir plus" pertinent seulement s'il reste des items non chargés.
  bool get hasSeeMore =>
      seeMoreEndpoint != null && totalCount > (page * limit);
}
