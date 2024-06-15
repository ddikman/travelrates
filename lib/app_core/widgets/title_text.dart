import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/typography.dart';

class TitleText extends StatelessWidget {
  final String text;

  const TitleText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: ThemeTypography.title);
  }
}
