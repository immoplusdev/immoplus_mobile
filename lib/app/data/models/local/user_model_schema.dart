import 'package:isar_community/isar.dart';
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

// Getter qui retourne le numéro sans le +225
  String? get number {
    if (phoneNumber == null) return null;
    if (phoneNumber!.startsWith('+225') && phoneNumber!.length > 4) {
      return phoneNumber!.substring(4);
    }
    if (phoneNumber!.startsWith('225') && phoneNumber!.length > 3) {
      return phoneNumber!.substring(3);
    }
    return phoneNumber;
  }
}
