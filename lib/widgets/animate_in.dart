import 'dart:async';

import 'package:flutter/material.dart';

class AnimateIn extends StatefulWidget {
  final Widget child;

  final Duration delay;

  final bool move;

  const AnimateIn(
      {Key key, this.child, this.delay = Duration.zero, this.move = true})
      : super(key: key);

  @override
  AnimateInState createState() {
    return new AnimateInState();
  }
}

class AnimateInState extends State<AnimateIn> with TickerProviderStateMixin {
  Animation<Offset> _animatedPosition;

  Animation<double> _animatedOpacity;

  AnimationController _controller;

  @override
  void initState() {
    _controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    _animatedPosition = new Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(new CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
    ));

    _animatedOpacity = new Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      new CurvedAnimation(parent: _controller, curve: Curves.ease),
    );

    new Future.delayed(widget.delay, () => _controller.forward());

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget animation =
        FadeTransition(child: widget.child, opacity: _animatedOpacity);

    if (widget.move) {
      animation = SlideTransition(
        child: animation,
        position: _animatedPosition,
      );
    }

    return animation;
  }
}
