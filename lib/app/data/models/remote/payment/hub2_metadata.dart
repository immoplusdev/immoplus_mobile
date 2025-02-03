import 'package:freezed_annotation/freezed_annotation.dart';

part 'hub2_metadata.freezed.dart';
part 'hub2_metadata.g.dart';

@freezed
class Hub2Metadata with _$Hub2Metadata {
  factory Hub2Metadata({
    @Default('') String id,
    @Default('') String token,
    @Default('') String status,
  }) = _Hub2Metadata;

  factory Hub2Metadata.fromJson(Map<String, dynamic> json) =>
      _$Hub2MetadataFromJson(json);
}
