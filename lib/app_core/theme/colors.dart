import 'dart:ui';

class ThemeColors {
  final Color background;
  final Color backgroundSecondary;
  final Color text;
  final Color text30;
  final Color text60;
  final Color red;
  final Color green;
  final Color accent;
  final Color accent30;

  const ThemeColors(
      {required this.background,
      required this.backgroundSecondary,
      required this.text,
      required this.text30,
      required this.text60,
      required this.red,
      required this.green,
      required this.accent,
      required this.accent30});
}

const ThemeColors lightTheme = ThemeColors(
    background: Color(0xfffdfdfd),
    backgroundSecondary: Color(0xfff2f2fb),
    text: Color(0xff181818),
    text30: Color(0x4d181818),
    text60: Color(0x99181818),
    red: Color(0xFFE57373),
    green: Color(0xFF81C784),
    accent: Color(0xFF2196F3),
    accent30: Color(0x4D2196F3));

const ThemeColors darkTheme = ThemeColors(
    background: Color(0xff202020),
    backgroundSecondary: Color(0xff383838),
    text: Color(0xfff5f5f5),
    text30: Color(0x4df5f5f5),
    text60: Color(0x99f5f5f5),
    red: Color(0xFFE57373),
    green: Color(0xFF81C784),
    accent: Color(0xFF2196F3),
    accent30: Color(0x4D2196F3));
