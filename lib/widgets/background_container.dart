import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/colors.dart';

class BackgroundContainer extends StatelessWidget {
  final child;

  const BackgroundContainer({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightTheme.background,
      child: child,
    );
  }
}
