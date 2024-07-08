import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/sizes.dart';
import 'package:travelconverter/app_core/theme/typography.dart';

class DarkModeSettingView extends StatelessWidget {
  const DarkModeSettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Dark mode', style: ThemeTypography.title),
          const SizedBox(height: Paddings.listGap),
          Row(
            children: [
              Switch(
                value: false,
                onChanged: (value) {},
              ),
              Switch(
                value: false,
                onChanged: (value) {},
              ),
              Switch(
                value: false,
                onChanged: (value) {},
              ),
            ],
          )
        ]);
  }
}
