import 'package:flutter/widgets.dart';
import 'package:travelconverter/app_core/theme/colors.dart';

abstract class ThemeTypography {
  static const fontFamily = 'Inter';

  static final title = TextStyle(
      color: lightTheme.text,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);

  static final smallBold = TextStyle(
      color: lightTheme.text,
      fontSize: 10,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);

  static final verySmallBold = TextStyle(
      color: lightTheme.text,
      fontSize: 8,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);

  static final large =
      TextStyle(color: lightTheme.text, fontSize: 26, fontFamily: fontFamily);
}
