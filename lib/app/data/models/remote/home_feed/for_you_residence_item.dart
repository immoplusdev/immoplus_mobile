import 'package:freezed_annotation/freezed_annotation.dart';

part 'for_you_residence_item.freezed.dart';
part 'for_you_residence_item.g.dart';

/// Carte résidence "légère" telle que renvoyée par `GET /me/home` — un
/// résumé pour l'affichage en carousel, pas le modèle résidence complet
/// (voir `ResidenceModel` pour la fiche détail).
@freezed
class ForYouResidenceItem with _$ForYouResidenceItem {
  const factory ForYouResidenceItem({
    required String residenceId,
    required String name,
    String? location,
    String? imageUrl,
    int? pricePerNight,
    String? currency,
    double? averageRating,
    int? totalReviews,
    @Default([]) List<ForYouReviewerAvatar> reviewerAvatars,
    int? reviewerCount,
    int? remainingCount,
    DateTime? createdAt,
    int? daysOld,
  }) = _ForYouResidenceItem;

  factory ForYouResidenceItem.fromJson(Map<String, dynamic> json) =>
      _$ForYouResidenceItemFromJson(json);
}

@freezed
class ForYouReviewerAvatar with _$ForYouReviewerAvatar {
  const factory ForYouReviewerAvatar({
    required String userId,
    String? firstName,
    String? lastName,
    String? avatarId,
  }) = _ForYouReviewerAvatar;

  factory ForYouReviewerAvatar.fromJson(Map<String, dynamic> json) =>
      _$ForYouReviewerAvatarFromJson(json);
}
