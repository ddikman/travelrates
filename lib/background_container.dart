import 'package:flutter/material.dart';
import 'package:backpacking_currency_converter/app_theme.dart';

class BackgroundContainer extends StatelessWidget {

  final child;

  const BackgroundContainer({Key key, this.child}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.accentColor.shade800,
                AppTheme.accentColor.shade200
              ])),
      child: child,
    );
  }

}