import 'package:flutter/material.dart';

extension ColumnExtensions on List<Widget> {
  List<Widget> separatedWith(Widget separator) {
    return expand((widget) => <Widget>[widget, separator]).toList()
      ..removeLast();
  }
}
