import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/ads/ad_campaign_model.dart';
import 'package:immoplus/app/data/models/remote/home_feed/for_you_bien_item.dart';
import 'package:immoplus/app/data/models/remote/home_feed/for_you_residence_item.dart';

part 'home_feed_list_item.freezed.dart';
part 'home_feed_list_item.g.dart';

/// Un élément du carousel d'une section `residence_list`/`bien_list` :
/// soit un bien/résidence (`itemType: "item"`), soit une pub interleavée
/// par le backend (`itemType: "ad"`, `ad.section_position == "inline"`).
@freezed
class HomeFeedListItem with _$HomeFeedListItem {
  const HomeFeedListItem._();

  const factory HomeFeedListItem({
    required String itemType,
    Map<String, dynamic>? item,
    AdCampaignModel? ad,
  }) = _HomeFeedListItem;

  factory HomeFeedListItem.fromJson(Map<String, dynamic> json) =>
      _$HomeFeedListItemFromJson(json);

  bool get isAd => itemType == 'ad' && ad != null;

  ForYouResidenceItem? get asResidence =>
      item == null ? null : ForYouResidenceItem.fromJson(item!);

  ForYouBienItem? get asBien =>
      item == null ? null : ForYouBienItem.fromJson(item!);
}

/// Une carte "ville" à l'intérieur d'une section `bien_groups_by_location`
/// (ex: la carte "Abidjan — 47 biens" dans `biens_a_louer_par_ville`), avec
/// son propre mini-carousel interne.
@freezed
class BienLocationGroup with _$BienLocationGroup {
  const factory BienLocationGroup({
    required String locationId,
    required String locationName,
    @Default(0) int itemCount,
    @Default(1) int page,
    @Default(10) int limit,
    String? seeMoreEndpoint,
    @Default([]) List<HomeFeedListItem> items,
  }) = _BienLocationGroup;

  factory BienLocationGroup.fromJson(Map<String, dynamic> json) =>
      _$BienLocationGroupFromJson(json);
}
