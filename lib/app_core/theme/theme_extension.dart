import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/theme_colors.dart';

extension ThemeExtension on BuildContext {
  ThemeColors get themeColors => isDarkMode ? darkTheme : lightTheme;

  bool get isDarkMode =>
      MediaQuery.of(this).platformBrightness == Brightness.dark;
}
