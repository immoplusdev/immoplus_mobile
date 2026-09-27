import 'package:freezed_annotation/freezed_annotation.dart';
import 'relais_model.dart';

part 'relais_response.freezed.dart';
part 'relais_response.g.dart';

@freezed
class RelaisResponse with _$RelaisResponse {
  const factory RelaisResponse({
    required RelaisModel data,
  }) = _RelaisResponse;

  factory RelaisResponse.fromJson(Map<String, dynamic> json) =>
      _$RelaisResponseFromJson(json);
}
