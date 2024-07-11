import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:travelconverter/app_core/theme/app_theme.dart';

// Styles have been added only as they are used so many missing style may need to be added
abstract class MarkdownStyle {
  static MarkdownStyleSheet of(BuildContext context) {
    return MarkdownStyleSheet(
      p: ThemeTypography.body,
      a: ThemeTypography.body.bold.copyWith(color: context.themeColors.accent),
    );
  }
}
