import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/app_theme.dart';
import 'package:travelconverter/app_core/widgets/utility_extensions.dart';

class AppSnackBar extends StatelessWidget {
  final String message;
  final Color accentColor;
  final IconData? icon;
  final SnackBarAction? action;

  AppSnackBar(
      {required this.message,
      required this.accentColor,
      this.icon,
      this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: context.themeColors.background,
          boxShadow: [
            BoxShadow(blurRadius: 4.0, color: Colors.black.withOpacity(0.25))
          ],
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
              ).pad(right: Paddings.small),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: context.themeColors.text),
              ),
            ),
            if (action != null)
              GestureDetector(
                onTap: () {
                  action!.onPressed();
                },
                behavior: HitTestBehavior.opaque,
                child: Text(action!.label,
                        style: TextStyle(
                            color: accentColor, fontWeight: FontWeight.bold))
                    .pad(left: Paddings.small),
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
      action: action,
    );

    final animatedSnackBar = AnimatedSnackBar(
        builder: (context) => snackBar,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        mobilePositionSettings: MobilePositionSettings(
          bottomOnAppearance: Paddings.large,
          left: Paddings.scaffold,
          right: Paddings.scaffold,
        ),
        duration: duration,
        animationCurve: Curves.easeOutBack,
        animationDuration: Duration(milliseconds: 500));
    animatedSnackBar.show(context);
  }
}
