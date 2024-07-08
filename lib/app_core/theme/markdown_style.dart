import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/app_core/theme/typography.dart';

// Styles have been added only as they are used so many missing style may need to be added
final markdownStyle = MarkdownStyleSheet(
  p: ThemeTypography.body,
  a: ThemeTypography.body.bold.copyWith(color: lightTheme.accent),
);
