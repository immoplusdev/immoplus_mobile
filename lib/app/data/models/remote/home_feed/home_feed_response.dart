import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus/app/data/models/remote/home_feed/home_feed_section.dart';

part 'home_feed_response.freezed.dart';
part 'home_feed_response.g.dart';

@freezed
class HomeFeedApiResponse with _$HomeFeedApiResponse {
  const factory HomeFeedApiResponse({
    required HomeFeedData data,
  }) = _HomeFeedApiResponse;

  factory HomeFeedApiResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeFeedApiResponseFromJson(json);
}

/// `data` de la réponse `GET /me/home`. Pagination à deux niveaux (voir
/// HOME FEED AGREGATOR.MD § 3) : `count`/`hasMore`/`nextCursor` paginent les
/// SECTIONS elles-mêmes (scroll vertical de la home) — à ne pas confondre
/// avec `page`/`limit`/`totalCount` à l'intérieur de chaque section, qui ne
/// concernent que les items de cette section précise.
@freezed
class HomeFeedData with _$HomeFeedData {
  const factory HomeFeedData({
    @Default(0) int count,
    @Default(false) bool hasMore,
    String? nextCursor,
    @Default([]) List<HomeFeedSection> sections,
    DateTime? generatedAt,
  }) = _HomeFeedData;

  factory HomeFeedData.fromJson(Map<String, dynamic> json) =>
      _$HomeFeedDataFromJson(json);
}
