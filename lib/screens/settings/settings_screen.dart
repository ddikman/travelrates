import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelconverter/widgets/background_container.dart';
import 'package:travelconverter/widgets/bottom_right_anchor.dart';
import 'package:travelconverter/widgets/button.dart';
import 'package:travelconverter/widgets/screen_title_text.dart';
import 'package:travelconverter/widgets/separated_column.dart';

import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

import 'greycastle_copyright.dart';

Color foreground = const Color(0xFF4796B2);

class SettingsScreen extends StatelessWidget {
  static String get screenTitle => Intl.message(
      "Settings",
      name: "SettingsScreen_screenTitle",
      desc: "Settings screen main title"
  );

  @override
  Widget build(BuildContext context) {
    final appBar = new AppBar(
      title: ScreenTitleText.show(screenTitle),
      centerTitle: true
    );

    return Scaffold(
      appBar: appBar,
      body: BackgroundContainer(
        child: BottomRightAnchor(
          anchored: GreycastleCopyright(),
          child: SettingsPageContent()
        ),
      )
    );
  }
}

class SettingsPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: separatedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        separator: Container(height: 8),
        children: [
          _title,
          _text,
          _contactButton
        ],
      ),
    );
  }

  Widget get _title => Text('About TravelRates'.toUpperCase(), style: TextStyle(color: foreground, fontSize: 20.0));

  Widget get _text => Text("""TravelRates was written in 2019 during a week of cold traveelling south east assia.

I wanted to learn Flutter and how to relaase and market an app and eheree we aree.

The point was to build an app for a specific audience, namely backpackers in this case. People who need to quickly compare beetweeen numerous curreencies but still keep it dead simple.

I like to think I’ve done an alright job.

So thank you very much for using the app! That’s why I built it.

If you care to make a contribution, suggeestion or interested in having someting built, ddon’t hesitate to get in touch.""", style: TextStyle(color: foreground));

  Widget get _contactButton => Padding(padding: EdgeInsets.symmetric(vertical: 8.0),child: Align(child:  Button(onTap: () => sendEmail(), text: 'Contact me'), alignment: Alignment.bottomRight));

  sendEmail() async {
    final mailtoLink = Mailto(
      to: ['david@greycastle.se'],
      subject: 'About TravelRates',
      body: 'Hi!\nI am emailing about TravelRates.',
    );

    await launch('$mailtoLink');
  }
}