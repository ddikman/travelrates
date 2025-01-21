import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:travelconverter/app_core/theme/markdown_style.dart';
import 'package:travelconverter/app_core/theme/app_theme.dart';
import 'package:travelconverter/app_core/widgets/app_button.dart';
import 'package:travelconverter/app_core/widgets/page_scaffold.dart';
import 'package:travelconverter/app_core/widgets/separated_extension.dart';
import 'package:travelconverter/l10n/l10n_extension.dart';
import 'package:travelconverter/use_cases/review_feature/app_review_service.dart';
import 'package:travelconverter/use_cases/about/dark_mode_selector_view.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(context.l10n.about_title, style: ThemeTypography.title),
        Text(context.l10n.about_description, style: ThemeTypography.body),
        AppButton(
            label: context.l10n.about_addReview,
            icon: Icons.exit_to_app,
            onPressed: () {
              AppReviewService().request();
            }),
        Markdown(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            onTapLink: (text, href, title) {
              if (href != null)
                launchUrl(Uri.parse(href),
                    mode: LaunchMode.externalApplication);
            },
            data: context.l10n.about_callout,
            styleSheet: MarkdownStyle.of(context)),
        const SizedBox(height: Paddings.listGap),
        const DarkModeSelectorView(),
      ].separatedWith(const SizedBox(height: Paddings.listGap)),
    ));
  }
}
