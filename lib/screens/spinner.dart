import 'dart:async';

import 'package:backpacking_currency_converter/app_theme.dart';
import 'package:flutter/material.dart';

class Spinner extends StatefulWidget {

  /// Time until which to not show the spinner
  final DateTime delayUntil;

  const Spinner({Key key, this.delayUntil}) : super(key: key);

  @override
  SpinnerState createState() {
    return new SpinnerState();
  }
}

class SpinnerState extends State<Spinner> with TickerProviderStateMixin {

  final loaderColor = AlwaysStoppedAnimation<Color>(AppTheme.primaryColor);

  Timer visibilityTimer;

  AnimationController _animationController;

  Animation<double> _opacity;

  SpinnerState() {
    final roughlyEachFrame = (1000.0 / 60.0).ceil();
    final timerInterval = Duration(milliseconds: roughlyEachFrame);
    visibilityTimer = Timer.periodic(timerInterval, _updateVisibility);
  }

  bool get _beforeDelay {
    if (widget.delayUntil == null) {
      return true;
    }

    return DateTime.now().millisecondsSinceEpoch < widget.delayUntil.millisecondsSinceEpoch;
  }

  bool invisible = true;

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 600));

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(new CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return invisible ? _invisibleLittlePlaceholder : _spinnerWidget;
  }

  Widget get _spinnerWidget =>
    new FadeTransition(
      opacity: _opacity,
      child: CircularProgressIndicator(
        strokeWidth: 5.0,
        valueColor: loaderColor,
      ),
    );

  Widget get _invisibleLittlePlaceholder => new Container(
    color: Colors.transparent,
    width: 1.0,
    height: 1.0,
  );

  /// gracefully wait until the spinner has stopped it's animation
  Future<Null> stopLoading() async {
    // simply return if we've not started animation
    if (invisible) {
      return;
    }

    await _animationController.reverse();
  }

  void _updateVisibility(Timer timer) {

    if (_beforeDelay) {
      return;
    }

    // no need to call the callback again
    timer.cancel();

    // make sure we render the spinner next up
    setState((){
      invisible = false;
    });

    // and start the animation
    _animationController.forward();
  }
}