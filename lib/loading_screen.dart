
import 'dart:async';

import 'package:backpacking_currency_converter/animate_in.dart';
import 'package:backpacking_currency_converter/background_container.dart';
import 'package:backpacking_currency_converter/state_container.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {

  @override
  _LoadingScreenState createState() {
    return new _LoadingScreenState();
  }

}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    _loadState();
    super.initState();
  }

  Future<Null> _loadState() async {
    await StateContainer.of(context).loadState();
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return new BackgroundContainer(
      child: new Center(
          child: new Container(
            width: 120.0,
            height: 120.0,
            child: _animated(_loader()),
          )),
    );
  }

  _loader() {
    final loaderColor = AlwaysStoppedAnimation<Color>(Colors.white);

    return CircularProgressIndicator(
      strokeWidth: 5.0,
      valueColor: loaderColor,
    );
  }

  Widget _animated(Widget child) {
    return new AnimateIn(child: child, move: false);
  }
}