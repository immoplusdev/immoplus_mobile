import 'package:freezed_annotation/freezed_annotation.dart';

part 'for_you_bien_item.freezed.dart';
part 'for_you_bien_item.g.dart';

/// Carte bien immobilier "légère" telle que renvoyée par `GET /me/home` —
/// voir `BienImmobilierModel` pour la fiche détail complète.
@freezed
class ForYouBienItem with _$ForYouBienItem {
  const factory ForYouBienItem({
    required String bienId,
    required String name,
    String? location,
    String? imageUrl,
    int? price,
    String? currency,
    String? typeBienImmobilier,
    @Default(false) bool aLouer,
    String? typeLocation,
  }) = _ForYouBienItem;

  factory ForYouBienItem.fromJson(Map<String, dynamic> json) =>
      _$ForYouBienItemFromJson(json);
}
