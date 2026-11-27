import 'package:shared_preferences/shared_preferences.dart';

/// Choix de l'utilisateur de couper les notifications sur cet appareil
/// (interrupteur du profil). Tant qu'il est actif, l'appareil n'est plus
/// enregistré pour les push, même si l'autorisation système est accordée.
class PushOptOutStore {
  PushOptOutStore._();

  static const _key = 'push_opt_out';

  static Future<bool> isOptedOut() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> setOptedOut(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}
