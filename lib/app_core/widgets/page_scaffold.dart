import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travelconverter/app_core/theme/app_theme.dart';
import 'package:travelconverter/app_core/widgets/app_bar_icon.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: context.themeColors.background60,
        surfaceTintColor: context.themeColors.background60,
        foregroundColor: context.themeColors.text,
        automaticallyImplyLeading: false,
        leading: appBarLeftAction ?? _backButton(context),
        actions: [
          (appBarRightAction ?? Container()).pad(right: Paddings.scaffold)
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: body.pad(
              left: Paddings.scaffold,
              right: Paddings.scaffold,
              top: Paddings.scaffoldTop),
        ),
      ),
    );
  }

  Widget? _backButton(BuildContext context) => context.canPop()
      ? AppBarIcon(icon: Icon(Icons.arrow_back_ios), onTap: () => context.pop())
      : null;
}
