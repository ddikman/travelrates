import 'package:flutter/widgets.dart';

abstract class ThemeTypography {
  static const fontFamily = 'Inter';

  static final title = TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, fontFamily: fontFamily);

  static final small = TextStyle(fontSize: 12, fontFamily: fontFamily);

  static final verySmall = TextStyle(fontSize: 10, fontFamily: fontFamily);

  static final large = TextStyle(fontSize: 26, fontFamily: fontFamily);

  static final inputText = TextStyle(fontSize: 32, fontFamily: fontFamily);

  static final body = TextStyle(fontSize: 14, fontFamily: fontFamily);
}

extension TextStyleExtension on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
}
