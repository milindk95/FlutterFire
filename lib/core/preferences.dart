import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_fire/models/models.dart';

class Preference {
  static const String _prefTheme = 'pref_theme';
  static const String _prefUser = 'pref_user';
  static const String _prefAuthToken = 'pref_auth_token';
  static const String _prefFirebaseToken = 'pref_firebase_token';

  /// Theme preference
  static Future<bool> setAppTheme(bool darkMode) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setBool(_prefTheme, darkMode);
  }

  static Future<bool?> getTheme() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(_prefTheme);
  }

  /// User preference
  static Future<void> setUserData(User user) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(_prefUser, json.encode(user));
  }

  static Future<User?> getUserData() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_prefUser) != null &&
            pref.getString(_prefUser)!.isNotEmpty
        ? User.fromJson(json.decode(pref.getString(_prefUser)!))
        : null;
  }

  /// Set user avatar
  static Future<void> setUserAvatar(String avatar) async {
    final pref = await SharedPreferences.getInstance();
    var user = await getUserData();
    await pref.setString(
        _prefUser, json.encode(user!.copyWith(avatar: avatar)));
  }

  static Future<bool> clearUserData() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(_prefAuthToken);
    await pref.remove(_prefUser);
    return true;
  }

  /// Auth token preference
  static Future<bool> setAuthToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setString(_prefAuthToken, token);
  }

  static Future<String> getAuthToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_prefAuthToken) ?? '';
  }

  /// Firebase token preference
  static Future<bool> setFirebaseToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setString(_prefFirebaseToken, token);
  }

  static Future<String> getFirebaseToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_prefFirebaseToken) ?? '';
  }
}
