import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Preferences preferences = Preferences();

class Preferences {
  Future<bool> clearAll() async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.clear();
  }

  Future<String> getUserToken() async {
    final prefs = await _prefs;
    return prefs.getString(_userTokenKey) ?? "";
  }

  Future<void> setUserToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(_userTokenKey, token);
  }

  Future<String> getURL() async {
    final prefs = await _prefs;
    return prefs.getString(_URLKey) ?? "";
  }

  Future<void> setURL(String url) async {
    final prefs = await _prefs;
    await prefs.setString(_URLKey, url);
  }

  // ------------------ SINGLETON -----------------------
  static final Preferences _preferences = Preferences._internal();

  factory Preferences() {
    return _preferences;
  }

  Preferences._internal();

  static const _storageKey = "flutter_flask_example_";
  static const _userTokenKey = _storageKey + 'user_token';
  static const _URLKey = _storageKey + 'url';
}
