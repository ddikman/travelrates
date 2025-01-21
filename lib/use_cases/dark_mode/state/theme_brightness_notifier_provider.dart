import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/services/preferences.dart';

class ThemeBrightnessNotifierProvider extends Notifier<ThemeMode> {
  static const _themeBrightnessSettingKey = 'theme_brightness_setting';

  Preferences get preferences => ref.read(preferencesProvider);

  @override
  ThemeMode build() {
    return preferences.getEnum(
      _themeBrightnessSettingKey,
      ThemeMode.values,
      ThemeMode.system,
    );
  }

  void setSetting(ThemeMode setting) {
    preferences.set(_themeBrightnessSettingKey, setting.toString());
    state = setting;
  }
}

final themeBrightnessNotifierProvider =
    NotifierProvider<ThemeBrightnessNotifierProvider, ThemeMode>(
  () => ThemeBrightnessNotifierProvider(),
);
