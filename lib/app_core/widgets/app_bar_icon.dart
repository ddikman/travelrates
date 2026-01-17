import 'package:flutter/material.dart';

class AppBarIcon extends StatelessWidget {
  static const double size = 64.0;

  final Widget icon;
  final Function onTap;

  const AppBarIcon({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: size,
            height: size,
            child: Center(child: icon),
          ),
          onTap: () => onTap()),
    );
  }
}
