// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';

part 'address.g.dart';

@unfreezed
class Address with _$Address {
  factory Address({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'placeId') String? placeId,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'alias') String? alias,
    @JsonKey(name: 'latitude') double? latitude,
    @JsonKey(name: 'longitude') double? longitude,
    // @JsonKey(name: 'phoneNumber') String? phoneNumber,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}
