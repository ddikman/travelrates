import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/app_core/theme/sizes.dart';
import 'package:travelconverter/app_core/widgets/app_bar_icon.dart';
import 'package:travelconverter/app_core/widgets/utility_extensions.dart';

class PageTopBar extends StatelessWidget {
  final Widget? leftAction;
  final Widget? rightAction;

  const PageTopBar({super.key, this.leftAction, this.rightAction});

  @override
  Widget build(BuildContext context) {
    final left = leftAction ?? _backChevron(context);
    final right = rightAction ?? SizedBox(height: 32.0);

    return Container(
      decoration: BoxDecoration(
        color: lightTheme.background60,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [left, right],
      ).pad(top: 48.0, bottom: Paddings.large),
    );
  }

  Widget _backChevron(BuildContext context) {
    if (context.canPop()) {
      return AppBarIcon(
          icon: Icon(Icons.chevron_left), onTap: () => context.pop());
    }

    return SizedBox(height: 32.0);
  }
}
