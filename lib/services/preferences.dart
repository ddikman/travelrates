import 'package:flutter_riverpod/flutter_riverpod.dart';

final preferencesProvider = Provider<Preferences>(
  (ref) => throw Exception("Not initialized"),
);

abstract class Preferences {
  bool? getBool(String key);
  double? getDouble(String key);
  int? getInt(String key);

  void setJson(String key, dynamic value);

  dynamic getJson(String key);

  T getEnum<T>(String key, List<T> values, T defaultValue) {
    final value = get(key);
    if (value == null) {
      return defaultValue;
    }

    return values.singleWhere((element) => element.toString() == value,
        orElse: () => defaultValue);
  }

  String? get(String key);

  bool hasKey(String key);

  void set(String key, dynamic value);

  void clear();

  void remove(String cacheKey);
}
