import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:travelconverter/app_core/theme/markdown_style.dart';
import 'package:travelconverter/app_core/theme/sizes.dart';
import 'package:travelconverter/app_core/theme/typography.dart';
import 'package:travelconverter/app_core/widgets/app_button.dart';
import 'package:travelconverter/app_core/widgets/page_scaffold.dart';
import 'package:travelconverter/app_core/widgets/separated_extension.dart';
import 'package:travelconverter/use_cases/about/dark_mode_setting_view.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('About Screen', style: ThemeTypography.title),
        Text(
            '''I first wrote and released TravelRates in 2019 in Bali whilst being sick with a cold when backpacking south east Asia.

It was built with backpackers in mind, where you have to compare against multiple currencies and speed, ease and offline use are more important than being exactly right.

Let me know if you enjoy the app, every review motivates me to keep it running (and free)!''',
            style: ThemeTypography.body),
        AppButton(label: 'Add review', onPressed: () => print('Add review')),
        Markdown(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            onTapLink: (text, href, title) {
              if (href != null)
                launchUrl(Uri.parse(href),
                    mode: LaunchMode.externalApplication);
            },
            data: '''I work as a freelance full stack developer.

If you want to get in touch, perhaps learn how this app is built or even hire me, visit [greycastle.se](https://greycastle.se).''',
            styleSheet: markdownStyle),
        const SizedBox(height: Paddings.listGap),
        const DarkModeSettingView(),
      ].separatedWith(const SizedBox(height: Paddings.listGap)),
    ));
  }
}
