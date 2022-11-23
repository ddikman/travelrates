import 'dart:async';

import 'package:flutter/material.dart';

class AnimateIn extends StatefulWidget {
  final Widget child;

  final Duration delay;

  const AnimateIn({Key? key, required this.child, this.delay = Duration.zero})
      : super(key: key);

  @override
  AnimateInState createState() {
    return new AnimateInState();
  }
}

class AnimateInState extends State<AnimateIn> with TickerProviderStateMixin {
  static final _defaultDuration = Duration(milliseconds: 400);

  late Animation<Offset> _animatedPosition;

  late Animation<double> _animatedOpacity;

  AnimationController? _controller;

  @override
  void initState() {
    _controller =
        new AnimationController(vsync: this, duration: _defaultDuration);

    _animatedPosition = new Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(new CurvedAnimation(
      parent: _controller!,
      curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
    ));

    _animatedOpacity = new Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      new CurvedAnimation(parent: _controller!, curve: Curves.ease),
    );

    new Future.delayed(widget.delay, startAnimation);

    super.initState();
  }

  void startAnimation() {
    _controller?.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      child: FadeTransition(child: widget.child, opacity: _animatedOpacity),
      position: _animatedPosition,
    );
  }
}
