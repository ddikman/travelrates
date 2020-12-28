import 'package:flutter/material.dart';

abstract class AppTheme {
  static const _primaryColorValue = 0xFF4796B2;

  static const _accentColorValue = 0xFFF0F0F0;

  static const primaryColor = const MaterialColor(
      _primaryColorValue,
    const {
        50 : const Color(0xFF244b59),
      100 : const Color(0xFF2b5a6b),
      200 : const Color(0xFF32697d),
      300 : const Color(0xFF39788e),
      400 : const Color(0xFF4087a0),
      500 : const Color(_primaryColorValue),
      600 : const Color(0xFF59a1ba),
      700 : const Color(0xFF6cabc1),
      800 : const Color(0xFF7eb6c9),
      900 : const Color(0xFF91c0d1),
    }
  );

  static const accentColor = const MaterialColor(
      _accentColorValue,
    const {
      50 : const Color(0xFF787878),
      100 : const Color(0xFF909090),
      200 : const Color(0xFFa8a8a8),
      300 : const Color(0xFFc0c0c0),
      400 : const Color(0xFFd8d8d8),
      500 : const Color(_accentColorValue),
      600 : const Color(0xFFf2f2f2),
      700 : const Color(0xFFf3f3f3),
      800 : const Color(0xFFf5f5f5),
      900 : const Color(0xFFf6f6f6),
    }
  );

  static final backgroundColor = Color(0xFFF0F0F0);

  static final accentColorLight = new Color(0xFFFFFFFF);

  static final deleteColour = new Color(0xFFdc002f);
}