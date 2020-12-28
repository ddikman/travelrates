import 'package:flutter/material.dart';

class BottomRightAnchor extends StatelessWidget {
  final Widget anchored;
  final Widget child;

  const BottomRightAnchor({Key key, this.anchored, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        this.child,
        Align(child: this.anchored, alignment: Alignment.bottomRight)
      ],
    );
  }
}