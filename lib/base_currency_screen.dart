
import 'package:flutter/material.dart';

import 'package:backpacking_currency_converter/background_container.dart';

class BaseCurrencyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Set base currency'),
      ),
      body: BackgroundContainer(child: Text('Base currency screen')),
    );
  }

}