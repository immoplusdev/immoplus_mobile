import 'package:flutter_test/flutter_test.dart';
import 'package:immoplus/app/core/enums/push_notification_type.dart';

void main() {
  group('PushNotificationType tests', () {
    test('fromString should map "alert" correctly', () {
      expect(PushNotificationType.fromString('alert'), PushNotificationType.alert);
      expect(PushNotificationType.fromString('ALERT'), PushNotificationType.alert);
    });

    test('getRoute should map alert notification type correctly', () {
      expect(PushNotificationType.alert.getRoute('123'), '/alerts/123/propositions');
      expect(PushNotificationType.alert.getRoute(null), isNull);
    });
  });
}
