import 'package:freezed_annotation/freezed_annotation.dart';

part 'property_badge_dto.freezed.dart';
part 'property_badge_dto.g.dart';

@freezed
class PropertyBadgeDto with _$PropertyBadgeDto {
  const factory PropertyBadgeDto({
    required String tier,
    required String label,
  }) = _PropertyBadgeDto;

  factory PropertyBadgeDto.fromJson(Map<String, dynamic> json) =>
      _$PropertyBadgeDtoFromJson(json);
}
