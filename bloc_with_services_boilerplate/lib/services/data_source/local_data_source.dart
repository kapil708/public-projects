import 'package:shared_preferences/shared_preferences.dart';

import '../../core/error/exceptions.dart';

const _authToken = "authToken";
const _user = "user";
const _language = "language";
const _themeMode = "themeMode";

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

  Future<void> cacheLanguage(String language) {
    return sharedPreferences.setString(_language, language);
  }

  Future<void> cacheThemeMode(String language) {
    return sharedPreferences.setString(_themeMode, language);
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

  String? getLanguage() {
    try {
      final String? jsonString = sharedPreferences.getString(_language);
      return jsonString;
    } on Exception catch (e) {
      throw RemoteException(statusCode: e.hashCode, message: e.toString());
    }
  }

  String? getThemeMode() {
    try {
      final String? jsonString = sharedPreferences.getString(_themeMode);
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
}
