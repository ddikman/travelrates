import 'package:flutter/widgets.dart';
import 'package:travelconverter/app_core/theme/colors.dart';

abstract class ThemeTypography {
  static const fontFamily = 'Inter';

  static final title = TextStyle(
      color: lightTheme.text,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily);

  static final small =
      TextStyle(color: lightTheme.text, fontSize: 12, fontFamily: fontFamily);

  static final verySmall =
      TextStyle(color: lightTheme.text, fontSize: 10, fontFamily: fontFamily);

  static final large =
      TextStyle(color: lightTheme.text, fontSize: 26, fontFamily: fontFamily);
}

extension TextStyleExtension on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
}
