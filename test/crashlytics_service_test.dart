import 'package:flutter_test/flutter_test.dart';
import 'package:immoplus/app/core/services/crashlytics_service.dart';
import 'package:immoplus/app/core/services/firebase_crashlytics_service_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeCrashlyticsService implements CrashlyticsService {
  bool collectionEnabled = true;
  String? userId;
  final List<String> logs = [];
  final Map<String, Object> customKeys = {};
  final List<dynamic> nonFatalErrors = [];

  @override
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    collectionEnabled = prefs.getBool('crashlytics_collection_consent') ?? true;
  }

  @override
  Future<void> setCollectionEnabled(bool enabled) async {
    collectionEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('crashlytics_collection_consent', enabled);
  }

  @override
  Future<bool> isCollectionEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('crashlytics_collection_consent') ?? collectionEnabled;
  }

  @override
  Future<void> setUserId(String userId) async {
    this.userId = userId;
  }

  @override
  Future<void> clearUserId() async {
    userId = null;
  }

  @override
  Future<void> log(String message) async {
    logs.add(message);
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    customKeys[key] = value;
  }

  @override
  Future<void> recordNonFatalError({
    required dynamic exception,
    required StackTrace? stackTrace,
    required String screen,
    required String feature,
    String? errorType,
    String? reason,
    Map<String, Object>? additionalContext,
  }) async {
    nonFatalErrors.add(exception);
  }

  @override
  Future<void> triggerControlledNonFatalError() async {
    await recordNonFatalError(
      exception: Exception('test'),
      stackTrace: StackTrace.current,
      screen: 'QATestScreen',
      feature: 'test',
    );
  }

  @override
  void triggerControlledAsyncError() {}

  @override
  void triggerControlledFatalCrash() {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CrashlyticsService Clean Architecture & Contract Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('CrashlyticsService contract adheres to Clean Architecture', () async {
      final CrashlyticsService service = FakeCrashlyticsService();

      await service.init();
      expect(await service.isCollectionEnabled(), isTrue);

      await service.setCollectionEnabled(false);
      expect(await service.isCollectionEnabled(), isFalse);

      await service.setUserId('user_12345');
      final fake = service as FakeCrashlyticsService;
      expect(fake.userId, equals('user_12345'));

      await service.clearUserId();
      expect(fake.userId, isNull);

      await service.recordNonFatalError(
        exception: Exception('Payment timed out'),
        stackTrace: StackTrace.current,
        screen: 'CheckoutPage',
        feature: 'payment',
        errorType: 'TimeoutException',
      );
      expect(fake.nonFatalErrors.length, equals(1));
    });

    test('FirebaseCrashlyticsServiceImpl is assignable to CrashlyticsService', () {
      expect(
        FirebaseCrashlyticsServiceImpl.new,
        isA<CrashlyticsService Function()>(),
      );
    });
  });
}
