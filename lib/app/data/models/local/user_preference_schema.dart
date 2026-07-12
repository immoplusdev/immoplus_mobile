import 'package:isar_community/isar.dart';

part 'user_preference_schema.g.dart';

@collection
class UserPreferenceSchema {
  Id id = Isar.autoIncrement;

  String? intentId;
  List<String> propertyTypeIds = [];
  List<String> locationIds = [];
  double? budgetMin;
  double? budgetMax;

  DateTime? createdAt;
}
