import 'package:isar/isar.dart';

part 'onboarding_schema.g.dart';

@collection
class OnboardingSchema {
  Id id = Isar.autoIncrement;

  /// Indique si l'utilisateur a déjà vu l'onboarding
  late bool hasReadOnboarding;

  /// Date à laquelle l'utilisateur a vu l'onboarding
  DateTime? readAt;
}
