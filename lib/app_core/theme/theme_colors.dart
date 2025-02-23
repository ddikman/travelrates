import 'package:flutter/material.dart';

class ThemeColors {
  final ThemeMode mode;
  final Color background;
  final Color background60;
  final Color backgroundSecondary;
  final Color text;
  final Color text30;
  final Color text60;
  final Color red;
  final Color green;
  final Color accent;
  final Color accent30;
  final Color contrastText;

  const ThemeColors({
    required this.mode,
    required this.background,
    required this.background60,
    required this.backgroundSecondary,
    required this.text,
    required this.text30,
    required this.text60,
    required this.red,
    required this.green,
    required this.accent,
    required this.accent30,
    required this.contrastText,
  });
}

const ThemeColors lightTheme = ThemeColors(
  mode: ThemeMode.light,
  background: Color(0xfffdfdfd),
  background60: Color(0x99fdfdfd),
  backgroundSecondary: Color(0xffF3F3F3),
  text: Color(0xff181818),
  text30: Color(0x4d181818),
  text60: Color(0x99181818),
  red: Color(0xFFE57373),
  green: Color(0xFF81C784),
  accent: Color(0xFF8079CF),
  accent30: Color(0x4D8079CF),
  contrastText: Color(0xfffdfdfd),
);

const ThemeColors darkTheme = ThemeColors(
  mode: ThemeMode.dark,
  background: Color(0xff202020),
  background60: Color(0x99202020),
  backgroundSecondary: Color(0xff383838),
  text: Color(0xfff5f5f5),
  text30: Color(0x4df5f5f5),
  text60: Color(0x99f5f5f5),
  red: Color(0xFFE57373),
  green: Color(0xFF81C784),
  accent: Color(0xFF8079CF),
  accent30: Color(0x4D8079CF),
  contrastText: Color(0xfffdfdfd),
);
