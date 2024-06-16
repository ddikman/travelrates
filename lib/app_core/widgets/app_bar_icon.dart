import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/sizes.dart';
import 'package:travelconverter/app_core/widgets/utility_extensions.dart';

class AppBarIcon extends StatelessWidget {
  final Widget icon;
  final Function onTap;

  const AppBarIcon({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: icon.pad(
          top: Paddings.scaffold,
          left: Paddings.large,
        ),
        onTap: () => onTap());
  }
}
