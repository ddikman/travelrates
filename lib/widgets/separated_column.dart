import 'package:flutter/material.dart';

Column separatedColumn({Key key,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  MainAxisSize mainAxisSize = MainAxisSize.max,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  TextDirection textDirection,
  VerticalDirection verticalDirection = VerticalDirection.down,
  TextBaseline textBaseline,
  @required List<Widget> children,
  @required Widget separator}) {

  final separatedChildren = separate(children, separator);

  return Column(
    key: key,
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    crossAxisAlignment: crossAxisAlignment,
    textDirection: textDirection,
    verticalDirection: verticalDirection,
    textBaseline: textBaseline,
    children: separatedChildren,
  );
}

List<T> separate<T>(List<T> items, T separator) {
  if (items.length < 2) {
    return items;
  }

  final separated = List<T>();
  for (var i = 0; i < items.length - 1; ++i) {
    separated.add(items[i]);
    separated.add(separator);
  }
  separated.add(items.last);
  return separated;
}