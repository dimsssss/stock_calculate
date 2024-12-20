import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    return;
  }

  static Future<void> save(String key, List<String> value) async {
    await _prefs.setString(key, jsonEncode(value));
  }

  static String get(String key) {
    final str = _prefs.getString(key);

    if (str == null || str.isEmpty) {
      return '';
    }

    return str;
  }

  static Future<void> saveReport(List<String> value) async {
    await _prefs.setString('report', jsonEncode(value));
  }
}
