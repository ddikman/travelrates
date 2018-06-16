import 'dart:async';

import 'package:backpacking_currency_converter/background_container.dart';
import 'package:backpacking_currency_converter/state_container.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() {
    return new _LoadingScreenState();
  }
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  Animation<double> _opacity;

  @override
  void initState() {
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 600));

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(new CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();
    _loadState();
    super.initState();
  }

  Future<Null> _loadState() async {
    await StateContainer.of(context).loadState();
    await _animationController.reverse();
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return new BackgroundContainer(
      child: new Center(
          child: new Container(
        width: 120.0,
        height: 120.0,
        child: _animation(_loader()),
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

  _animation(Widget child) {
    return new FadeTransition(
      opacity: _opacity,
      child: child,
    );
  }
}
