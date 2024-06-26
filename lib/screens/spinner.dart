import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/colors.dart';

class Spinner extends StatefulWidget {
  /// Time until which to not show the spinner
  final Duration delay;

  Spinner({Key? key, required this.delay}) : super(key: key);

  @override
  SpinnerState createState() {
    return new SpinnerState();
  }
}

class SpinnerState extends State<Spinner> with TickerProviderStateMixin {
  final loaderColor = AlwaysStoppedAnimation<Color>(lightTheme.accent);

  AnimationController? _animationController;

  late Animation<double> _opacity;

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 600));

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(new CurvedAnimation(
        parent: _animationController!, curve: Curves.easeInOut));

    Future.delayed(widget.delay, _fadeIn);
  }

  _fadeIn() {
    _animationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = _calculateSize(context);
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: new FadeTransition(
          opacity: _opacity,
          child: CircularProgressIndicator(
            strokeWidth: 5.0,
            valueColor: loaderColor,
          ),
        ),
      ),
    );
  }

  /// gracefully wait until the spinner has stopped it's animation
  Future<Null> stopLoading() async {
    // simply return if we've not started animation
    if (_animationController == null || _animationController!.isDismissed) {
      return;
    }

    await _animationController?.reverse();
  }

  _calculateSize(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final limitingSide = min(screenSize.width, screenSize.height);
    final fillFactor = 0.6;
    return fillFactor * limitingSide;
  }
}
