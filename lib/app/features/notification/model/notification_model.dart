import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String? type,
    required String? subject,
    required String? message,
    required String? collection,
    required String? item,
    required String? recipient,
    required DateTime? createdAt,
    required DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
