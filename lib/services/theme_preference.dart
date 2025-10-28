import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {
  static const String _themeKey = 'theme';

  static Future<String?> getTheme() async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString(_themeKey);
  }

  static Future<void> setTheme(String val) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(_themeKey, val);
  }

  static Future<void> clearTheme() async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.remove(_themeKey);
  }
}
