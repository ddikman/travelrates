import 'dart:async';

import 'package:backpacking_currency_converter/app_routes.dart';
import 'package:backpacking_currency_converter/app_theme.dart';
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
    final stateContainer = StateContainer.of(context);
    await stateContainer.loadState();
    await _animationController.reverse();
    await Navigator.of(context).pushReplacementNamed(AppRoutes.home);

    if (stateContainer.appState.currencies.isEmpty) {
      // there's no easy way to guess the users preffered currency since locale is
      // language and not country so instead, let the user select her first currency
      await Navigator.of(context).pushNamed(AppRoutes.addCurrency);
    }
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
    final loaderColor = AlwaysStoppedAnimation<Color>(AppTheme.primaryColor);

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
