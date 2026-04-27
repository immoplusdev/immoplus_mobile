import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum NotificationType {
  alert('alert', Icons.notifications_active, Colors.orange),
  proposal('proposal', Icons.home_work, Colors.blue),
  visit('visit', Icons.calendar_month, Colors.purple),
  payment('payment', Icons.account_balance_wallet, Colors.green),
  message('message', Icons.chat_bubble, Colors.indigo),
  system('system', Icons.info, Colors.grey);

  final String value;
  final IconData icon;
  final Color color;
  const NotificationType(this.value, this.icon, this.color);

  static NotificationType fromString(String? value) {
    if (value == null) return NotificationType.system;
    final lowerValue = value.toLowerCase();
    return NotificationType.values.firstWhere(
      (e) => lowerValue.contains(e.value),
      orElse: () => NotificationType.system,
    );
  }
}

@freezed
class NotificationModel with _$NotificationModel {
  const NotificationModel._();

  const factory NotificationModel({
    required String id,
    required String? type,
    required String? pushType,
    required String? subject,
    required String? message,
    required String? collection,
    required String? item,
    required String? recipient,
    required DateTime? readAt,
    required DateTime? createdAt,
    required DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  NotificationType get typeEnum =>
      NotificationType.fromString(pushType ?? type);

  bool get readStatus => readAt != null;
}
