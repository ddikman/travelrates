import 'package:flutter/material.dart';

import '../../app_routes.dart';

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings, color: Colors.white),
      iconSize: 24,
      onPressed: () {
        Navigator.of(context).pushNamed(AppRoutes.settings);
      },
    );
  }
}