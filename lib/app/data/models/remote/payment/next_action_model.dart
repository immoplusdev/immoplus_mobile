import 'package:freezed_annotation/freezed_annotation.dart';

part 'next_action_model.freezed.dart';
part 'next_action_model.g.dart';

@freezed
class NextActionData with _$NextActionData {
  const factory NextActionData({
    @Default('') String url,
    @Default('') String method,
  }) = _NextActionData;

  factory NextActionData.fromJson(Map<String, dynamic> json) =>
      _$NextActionDataFromJson(json);
}

@freezed
class Hub2NextAction with _$Hub2NextAction {
  const factory Hub2NextAction({
    @Default('') String type,
    @Default('') String message,
    @Default(NextActionData()) NextActionData data,
  }) = _Hub2NextAction;

  factory Hub2NextAction.fromJson(Map<String, dynamic> json) =>
      _$Hub2NextActionFromJson(json);
}
