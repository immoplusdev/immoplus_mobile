import 'package:isar/isar.dart';
part 'user_model_schema.g.dart';

@collection
class UserModelSchema {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? userId;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  @Index(unique: true, replace: true)
  String? email;
  String? accessToken;
  String? refreshToken;
  String? roleName;
  String? activite;
  String? nomEntreprise;
  String? emailEntreprise;
  String? photoIdentite;
  String? pieceIdentite;
  String? avatar;
  String? role;
}
