import 'package:travelconverter/services/preferences.dart';

class MockPreferences extends Preferences {
  final Map<String, dynamic> _store = {};

  @override
  String? get(String key) => _store[key]?.toString();

  @override
  bool? getBool(String key) => _store[key] as bool?;

  @override
  double? getDouble(String key) => _store[key] as double?;

  @override
  int? getInt(String key) => _store[key] as int?;

  @override
  dynamic getJson(String key) => _store[key];

  @override
  bool hasKey(String key) => _store.containsKey(key);

  @override
  void set(String key, dynamic value) => _store[key] = value;

  @override
  void setJson(String key, dynamic value) => _store[key] = value;

  @override
  void clear() => _store.clear();

  @override
  void remove(String cacheKey) => _store.remove(cacheKey);
}
