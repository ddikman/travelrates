import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/app_core/theme/sizes.dart';

class AppSnackBar extends StatelessWidget {
  final String message;
  final Color accentColor;
  final IconData? icon;

  AppSnackBar({required this.message, required this.accentColor, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: lightTheme.background,
          borderRadius: BorderRadius.circular(Rounding.small),
          border: Border.all(color: accentColor)),
      child: Padding(
        padding: const EdgeInsets.all(Paddings.medium),
        child: Row(
          children: <Widget>[
            if (icon != null)
              Icon(
                icon,
                size: 16.0,
                color: accentColor,
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  message,
                  style: TextStyle(color: accentColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static showError(BuildContext context, String message) {
    show(context,
        accentColor: Colors.red,
        duration: Duration(seconds: 5),
        text: message,
        icon: Icons.error_outline);
  }

  static showSuccess(BuildContext context, String message) {
    show(context,
        accentColor: Colors.green,
        duration: Duration(seconds: 1),
        text: message,
        icon: Icons.check_circle);
  }

  static show(BuildContext context,
      {required Color accentColor,
      required Duration duration,
      required String text,
      SnackBarAction? action,
      IconData? icon}) {
    final snackBar = AppSnackBar(
      message: text,
      accentColor: accentColor,
      icon: icon,
    );

    // TODO: This animation now only works on fade in not on movement
    const figmaGentleCurve = Cubic(0.47, 0, 0.23, 1.38);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: snackBar,
          action: action,
          duration: duration,
          // animation: animation,
          padding: EdgeInsets.all(0),
          behavior: SnackBarBehavior.floating),
      snackBarAnimationStyle: AnimationStyle(
        curve: figmaGentleCurve,
        duration: Duration(milliseconds: 800),
      ),
    );
  }
}
