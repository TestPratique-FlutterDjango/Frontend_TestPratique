import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class LocalStorage {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save User Data (as JSON string)
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    final userDataString = jsonEncode(userData);
    return _prefs.setString(ApiConstants.userDataKey, userDataString);
  }

  // Get User Data
  Map<String, dynamic>? getUserData() {
    final userDataString = _prefs.getString(ApiConstants.userDataKey);
    if (userDataString != null) {
      return jsonDecode(userDataString) as Map<String, dynamic>;
    }
    return null;
  }

  // Delete User Data
  Future<bool> deleteUserData() async {
    return _prefs.remove(ApiConstants.userDataKey);
  }

  // Save Login Status
  Future<bool> saveLoginStatus(bool isLoggedIn) async {
    return _prefs.setBool(ApiConstants.isLoggedInKey, isLoggedIn);
  }

  // Get Login Status
  bool isLoggedIn() {
    return _prefs.getBool(ApiConstants.isLoggedInKey) ?? false;
  }

  // Generic Save String
  Future<bool> saveString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  // Generic Get String
  String? getString(String key) {
    return _prefs.getString(key);
  }

  // Generic Save Int
  Future<bool> saveInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  // Generic Get Int
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // Generic Save Bool
  Future<bool> saveBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  // Generic Get Bool
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // Generic Save Double
  Future<bool> saveDouble(String key, double value) async {
    return  _prefs.setDouble(key, value);
  }

  // Generic Get Double
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // Generic Save List<String>
  Future<bool> saveStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  // Generic Get List<String>
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // Remove specific key
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // Clear all data
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  // Check if key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // Get all keys
  Set<String> getKeys() {
    return _prefs.getKeys();
  }
}