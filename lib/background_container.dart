import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {

  final child;

  const BackgroundContainer({Key key, this.child}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[100],
                Colors.blue[300],
              ])),
      child: child,
    );
  }

}