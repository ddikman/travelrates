import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/app_theme.dart';

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
          backgroundColor: context.themeColors.accent,
          foregroundColor: context.themeColors.backgroundSecondary,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Rounding.small),
          )),
      onPressed: () => onPressed(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.themeColors.contrastText,
                ),
          ),
          if (icon != null) ...[
            const SizedBox(width: Paddings.listGap),
            Icon(icon, size: 16.0, color: context.themeColors.contrastText),
          ],
        ],
      ),
    );
  }
}
