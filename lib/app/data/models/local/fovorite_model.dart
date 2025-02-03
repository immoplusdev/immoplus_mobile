import 'package:isar/isar.dart';

part 'fovorite_model.g.dart';

@collection
class FovoriteModel {
  Id id = Isar.autoIncrement;
  String? name;
  @Index(type: IndexType.value, unique: true)
  String? itemId;
  List<String>? images;
  String? type;
  String? adress;
  String? destination;
  DateTime? date;
}
