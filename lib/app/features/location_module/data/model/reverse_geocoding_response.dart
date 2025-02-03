// ignore_for_file: invalid_annotation_target, constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'reverse_geocoding_response.freezed.dart';
part 'reverse_geocoding_response.g.dart';

@freezed
class ReverseGeocodingResponse with _$ReverseGeocodingResponse {
  const factory ReverseGeocodingResponse({
    @JsonKey(name: "plus_code") PlusCode? plusCode,
    @JsonKey(name: "results") @Default([]) List<Result> results,
    String? status,
  }) = _ReverseGeocodingResponse;

  factory ReverseGeocodingResponse.fromJson(Map<String, dynamic> json) =>
      _$ReverseGeocodingResponseFromJson(json);
}

@freezed
class PlusCode with _$PlusCode {
  const factory PlusCode({
    @JsonKey(name: "compound_code") String? compoundCode,
    @JsonKey(name: "global_code") String? globalCode,
  }) = _PlusCode;

  factory PlusCode.fromJson(Map<String, dynamic> json) =>
      _$PlusCodeFromJson(json);
}

@freezed
class Result with _$Result {
  const factory Result({
    @JsonKey(name: "address_components")
    @Default([])
    List<AddressComponent> addressComponents,
    @JsonKey(name: "formatted_address") String? formattedAddress,
    @JsonKey(name: "geometry") Geometry? geometry,
    @JsonKey(name: "place_id") String? placeId,
    @JsonKey(name: "types") @Default([]) List<String> types,
  }) = _Result;

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
}

@freezed
class AddressComponent with _$AddressComponent {
  const factory AddressComponent({
    @JsonKey(name: "long_name") String? longName,
    @JsonKey(name: "short_name") String? shortName,
    @JsonKey(name: "types") @Default([]) List<String> types,
  }) = _AddressComponent;

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      _$AddressComponentFromJson(json);
}

enum AddressComponentType {
  plus_code,
  street_address,
  route,
  sublocality,
  locality,
}

@freezed
class Geometry with _$Geometry {
  const factory Geometry({
    @JsonKey(name: "location") Location? location,
    @JsonKey(name: "location_type") String? locationType,
    @JsonKey(name: "viewport") Viewport? viewport,
  }) = _Geometry;

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);
}

enum GeometryType {
  GEOMETRIC_CENTER,
}

@freezed
class Location with _$Location {
  const factory Location({
    @JsonKey(name: "lat") double? lat,
    @JsonKey(name: "lng") double? lng,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}

@freezed
class Viewport with _$Viewport {
  const factory Viewport({
    @JsonKey(name: "northeast") Location? northeast,
    @JsonKey(name: "southwest") Location? southwest,
  }) = _Viewport;

  factory Viewport.fromJson(Map<String, dynamic> json) =>
      _$ViewportFromJson(json);
}
