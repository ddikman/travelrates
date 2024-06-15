import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/app_routes.dart';
import 'package:flutter/material.dart';

class OpenAddCurrencyScreenButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add, color: lightTheme.background),
      backgroundColor: lightTheme.accent,
      onPressed: () {
        Navigator.of(context).pushNamed(AppRoutes.addCurrency);
      },
    );
  }
}
