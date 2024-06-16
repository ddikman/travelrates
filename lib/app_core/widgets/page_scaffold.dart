import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/sizes.dart';

class PageScaffold extends StatelessWidget {
  final Widget body;
  final Widget? appBarLeftAction;
  final Widget? appBarRightAction;
  final Key? scaffoldKey;

  PageScaffold(
      {required this.body,
      this.appBarLeftAction,
      this.appBarRightAction,
      this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: appBarLeftAction,
        actions: [appBarRightAction ?? Container()],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(
            left: Paddings.scaffold,
            right: Paddings.scaffold,
            top: 0.0,
            bottom: Paddings.scaffold),
        child: body,
      )),
    );
  }
}
