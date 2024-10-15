import 'package:shared_preferences/shared_preferences.dart';

import '../../core/error/exceptions.dart';

const _authToken = "authToken";
const _user = "user";
const _languagePrefs = "languagePrefs";
const _themePrefs = "themePrefs";

class LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSource({required this.sharedPreferences});

  Future<bool> isLogin() {
    try {
      final String? jsonString = sharedPreferences.getString(_authToken);
      if (jsonString != null) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } on Exception catch (e) {
      throw RemoteException(statusCode: e.hashCode, message: e.toString());
    }
  }

  Future<void> cacheAuthToken(String authToken) {
    return sharedPreferences.setString(_authToken, authToken);
  }

  Future<void> cacheUser(String user) {
    return sharedPreferences.setString(_user, user);
  }

  Future<void> removeAuthToken() {
    return sharedPreferences.remove(_authToken);
  }

  Future<void> removeUser() {
    return sharedPreferences.remove(_user);
  }

  String? getAuthToken() {
    try {
      final String? jsonString = sharedPreferences.getString(_authToken);
      return jsonString;
    } on Exception catch (e) {
      throw RemoteException(statusCode: e.hashCode, message: e.toString());
    }
  }

  String? getUser() {
    try {
      final String? jsonString = sharedPreferences.getString(_user);
      return jsonString;
    } on Exception catch (e) {
      throw RemoteException(statusCode: e.hashCode, message: e.toString());
    }
  }

  Future<void> cacheLanguage(String languageCode) {
    return sharedPreferences.setString(_languagePrefs, languageCode);
  }

  Future<void> cacheThemeMode(String themeModeName) {
    return sharedPreferences.setString(_themePrefs, themeModeName);
  }

  String? getLanguage() {
    try {
      final String? jsonString = sharedPreferences.getString(_languagePrefs);
      return jsonString;
    } on Exception catch (e) {
      throw RemoteException(statusCode: e.hashCode, message: e.toString());
    }
  }

  String? getThemeMode() {
    try {
      final String? jsonString = sharedPreferences.getString(_themePrefs);
      return jsonString;
    } on Exception catch (e) {
      throw RemoteException(statusCode: e.hashCode, message: e.toString());
    }
  }
}
