import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage.internal();

  factory LocalStorage() => _instance;

  LocalStorage.internal();

  static bool _isInitialized = false;
  static SharedPreferences? _preferences;

  static Future<LocalStorage> getInstance() async {
    if (!_isInitialized) {
      await _initialize();
      _isInitialized = true;
    }
    return _instance;
  }

  static Future<void> _initialize() async {
    _preferences = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  static Future<void> setString(String key, String value) async {
    await _preferences!.setString(key, value);
  }

  static String? getString(String key) {
    return _preferences!.getString(key);
  }

  static void remove(String key) {
    _preferences!.remove(key);
  }

  static Future<void> setItem(String key, dynamic value) async {
    String type = value.runtimeType.toString();
    switch (type) {
      case 'int':
        await _preferences!.setInt(key, value);
        break;
      case 'double':
        await _preferences!.setDouble(key, value);
        break;
      case 'bool':
        await _preferences!.setBool(key, value);
        break;
      case 'string':
        await _preferences!.setString(key, value);
        break;
      case 'List<String>':
        await _preferences!.setStringList(key, value);
        break;
      case '_Map<String, dynamic>':
      case '_Map<String, String>':
        await _preferences!.setString(key, jsonEncode(value));
        break;
    }
  }

  static dynamic getItem(String key) {
    dynamic value = _preferences!.get(key);
    return value;
  }

  static dynamic getMapItem(String key) {
    String value = _preferences!.getString(key) ?? '{}';
    return jsonDecode(value);
  }
}
