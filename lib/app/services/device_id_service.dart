import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Identifiant anonyme persisté localement, utilisé par le backend pour le
/// `userHasVoted` des sondages (`poll_banner`) quand l'utilisateur n'est pas
/// authentifié. Ignoré côté serveur si un JWT valide est fourni.
@lazySingleton
class DeviceIdService {
  static const _prefsKey = 'for_you_device_id';

  String? _cachedId;

  Future<String> getDeviceId() async {
    if (_cachedId != null) return _cachedId!;
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_prefsKey);
    if (id == null) {
      id = const Uuid().v4();
      await prefs.setString(_prefsKey, id);
    }
    _cachedId = id;
    return id;
  }
}
