import 'package:backpacking_currency_converter/app_routes.dart';
import 'package:flutter/material.dart';

class AddCurrencyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pushNamed(AppRoutes.addCurrency);
      },
    );
  }
}