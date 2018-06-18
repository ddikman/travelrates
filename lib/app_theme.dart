import 'package:flutter/material.dart';

abstract class AppTheme {
  static const _primaryColorValue = 0xFF3b9eb8;

  static const _accentColorValue = 0xFFF0F0F0;

  static const primaryColor = const MaterialColor(
      _primaryColorValue,
    const {
        50 : const Color(0xFF1e4f5c),
      100 : const Color(0xFF235f6e),
      200 : const Color(0xFF296f81),
      300 : const Color(0xFF2f7e93),
      400 : const Color(0xFF358ea6),
      500 : const Color(_primaryColorValue),
      600 : const Color(0xFF4fa8bf),
      700 : const Color(0xFF62b1c6),
      800 : const Color(0xFF76bbcd),
      900 : const Color(0xFF89c5d4),
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

  static final accentColorLight = new Color(0xFFFFFFFF);
}