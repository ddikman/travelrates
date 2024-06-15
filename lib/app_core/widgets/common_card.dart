import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/app_core/theme/sizes.dart';
import 'package:travelconverter/app_core/widgets/utility_extensions.dart';

class CommonCard extends StatelessWidget {
  final Widget child;
  final Function? onTap;

  CommonCard({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    final container = Container(
        decoration: BoxDecoration(
          color: lightTheme.backgroundSecondary,
          borderRadius: BorderRadius.circular(Rounding.large),
        ),
        child: child.padAll(Paddings.medium));

    if (onTap == null) {
      return container;
    }

    return GestureDetector(
      onTap: () => onTap!(),
      child: container,
    );
  }
}
