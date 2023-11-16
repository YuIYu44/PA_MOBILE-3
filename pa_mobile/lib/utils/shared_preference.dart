import 'package:shared_preferences/shared_preferences.dart';

class preference {
  SharedPreferences? prefs;

  set(key, value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future get(key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) == null ? null : prefs.getString(key);
  }
}
