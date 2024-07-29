import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setPseudo(String pseudo) async {
    await _preferences?.setString('pseudo', pseudo);
  }

  static String? getPseudo() {
    return _preferences?.getString('pseudo');
  }
}
