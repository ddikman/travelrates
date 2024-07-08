import 'package:flutter/material.dart';

extension ColumnExtensions on List<Widget> {
  List<Widget> separatedWith(Widget separator) {
    return this.expand((widget) => <Widget>[widget, separator]).toList()
      ..removeLast();
  }
}
