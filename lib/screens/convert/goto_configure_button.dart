import 'dart:io';

import 'package:intl/intl.dart';
import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/app_routes.dart';
import 'package:flutter/material.dart';

class GotoConfigureButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Since iOS and Android has a little different methods of showing menus
    // this button has been made platform specific to make both kind of users
    // feel more at home
    return Platform.isAndroid
        ? _buildAndroidButton(context)
        : _buildIOSButton(context);
  }

  Widget _buildAndroidButton(BuildContext context) {
    return new IconButton(
      icon: Icon(Icons.mode_edit, color: lightTheme.text),
      iconSize: 32.0,
      onPressed: () => _navigateToEdit(context),
    );
  }

  Widget _buildIOSButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0, top: 4.0),
        child: new GestureDetector(
          onTap: () => _navigateToEdit(context),
          child: Text(_editButtonLabel,
              style: TextStyle(fontSize: 20.0, color: lightTheme.text)),
        ),
      ),
    );
  }

  String get _editButtonLabel => Intl.message('Edit',
      name: '_editButtonLabel',
      desc: 'Text for edit button on currency convert screen');

  void _navigateToEdit(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.edit);
  }
}
