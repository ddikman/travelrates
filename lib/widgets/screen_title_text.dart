import 'dart:io';

import 'package:flutter/cupertino.dart';

class ScreenTitleText extends StatelessWidget {
  final String _title;

  const ScreenTitleText({Key? key, required String title})
      : this._title = title,
        super(key: key);

  factory ScreenTitleText.show(String title) {
    return new ScreenTitleText(title: _forPlatform(title));
  }

  /// For android, uppercase the title
  static String _forPlatform(String title) {
    return Platform.isAndroid ? title.toUpperCase() : title;
  }

  @override
  Widget build(BuildContext context) {
    return new Text(_title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0));
  }
}
