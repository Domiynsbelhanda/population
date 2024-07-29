import 'package:geolocator/geolocator.dart';
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


Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Vérifie si le service de localisation est activé.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Les services de localisation ne sont pas activés, ne continuez pas
    // à accéder à la position et demandez à l'utilisateur de les activer.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Les permissions sont refusées, la prochaine fois vous pourriez demander
      // les permissions encore (le meilleur endroit pour cela est le
      // code lié à l'action de l'utilisateur qui nécessite la localisation).
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Les permissions sont refusées pour toujours, les requêtes de permissions
    // ne peuvent plus aider.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // Lorsque les permissions sont accordées, continuez à accéder à la position de l'appareil.
  return await Geolocator.getCurrentPosition();
}