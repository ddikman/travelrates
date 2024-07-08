import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/app_core/theme/sizes.dart';

class AppButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final IconData? icon;

  const AppButton(
      {super.key, required this.label, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: lightTheme.accent,
          foregroundColor: lightTheme.backgroundSecondary,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Rounding.small),
          )),
      onPressed: () => onPressed(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(label),
          if (icon != null) ...[
            const SizedBox(width: Paddings.listGap),
            Icon(icon, size: 16.0)
          ],
        ],
      ),
    );
  }
}
