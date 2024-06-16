import 'package:flutter/widgets.dart';

extension PadExtension on Widget {
  Widget padAll(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  Widget pad({double? left, double? top, double? right, double? bottom}) {
    return Padding(
      padding: EdgeInsets.only(
          left: left ?? 0.0,
          top: top ?? 0.0,
          right: right ?? 0.0,
          bottom: bottom ?? 0.0),
      child: this,
    );
  }
}
