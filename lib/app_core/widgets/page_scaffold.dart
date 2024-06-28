import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/sizes.dart';
import 'package:travelconverter/app_core/widgets/page_top_bar.dart';
import 'package:travelconverter/app_core/widgets/utility_extensions.dart';

class PageScaffold extends StatelessWidget {
  final Widget body;
  final Widget? appBarLeftAction;
  final Widget? appBarRightAction;
  final Key? scaffoldKey;
  final bool transparent;

  PageScaffold(
      {required this.body,
      this.appBarLeftAction,
      this.appBarRightAction,
      this.scaffoldKey,
      this.transparent = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: transparent ? Colors.transparent : null,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: body.pad(
                left: Paddings.scaffold,
                right: Paddings.scaffold,
                top: Paddings.scaffoldTop),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: PageTopBar(
              leftAction: appBarLeftAction,
              rightAction: appBarRightAction,
            ),
          ),
        ],
      ),
    );
  }
}
