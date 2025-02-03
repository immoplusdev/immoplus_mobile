import 'package:freezed_annotation/freezed_annotation.dart';
import 'data_model.dart';

part 'data_wrapper.freezed.dart';
part 'data_wrapper.g.dart';

@freezed
class DataWrapper with _$DataWrapper {
  const factory DataWrapper({
    @JsonKey(name: 'data') required DataModel data,
  }) = _DataWrapper;

  factory DataWrapper.fromJson(Map<String, dynamic> json) =>
      _$DataWrapperFromJson(json);
}
