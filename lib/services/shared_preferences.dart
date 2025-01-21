import 'dart:convert';

import 'package:travelconverter/services/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart' as shared_prefs_lib;

class SharedPreferences extends Preferences {
  /// private constructor to force initialization using the @initialize method
  SharedPreferences._(this._instance, this._prefix);

  final shared_prefs_lib.SharedPreferences _instance;
  final String _prefix;

  static Future<SharedPreferences> initialize({String prefix = ''}) async {
    final instance = await shared_prefs_lib.SharedPreferences.getInstance();
    return SharedPreferences._(instance, prefix);
  }

  String _getKey(String key) => '$_prefix$key';

  @override
  String? get(String key) => _instance.get(_getKey(key)) as String?;

  @override
  bool? getBool(String key) => _instance.getBool(_getKey(key));

  @override
  double? getDouble(String key) => _instance.getDouble(_getKey(key));

  @override
  int? getInt(String key) => _instance.getInt(_getKey(key));

  @override
  dynamic getJson(String key) {
    final value = get(key);
    if (value == null) {
      return null;
    }

    return jsonDecode(value);
  }

  @override
  bool hasKey(String key) => _instance.get(_getKey(key)) != null;

  @override
  void setJson(String key, dynamic value) {
    set(key, jsonEncode(value));
  }

  @override
  void set(String key, dynamic value) {
    final internalKey = _getKey(key);
    if (value is double) {
      _instance.setDouble(internalKey, value);
    } else if (value is int) {
      _instance.setInt(internalKey, value);
    } else if (value is bool) {
      _instance.setBool(internalKey, value);
    } else if (value is List<String>) {
      _instance.setStringList(internalKey, value);
    } else {
      _instance.setString(internalKey, value.toString());
    }
  }

  @override
  void clear() {
    _instance.clear();
  }

  @override
  void remove(String cacheKey) {
    _instance.remove(cacheKey);
  }
}
