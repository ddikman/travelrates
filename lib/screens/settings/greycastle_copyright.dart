import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:travelconverter/screens/settings/settings_screen.dart';

class GreycastleCopyright extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final copyright = 'Copyright Greycastle 2020';
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version = snapshot.hasData ? _getVersion(snapshot.data) : "";
        return Container(
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                child: Text('$version$copyright'.toUpperCase(), style: TextStyle(color: foreground), textAlign: TextAlign.right)));
      },
    );
  }

  String _getVersion(PackageInfo packageInfo) {
    return "Version ${packageInfo.version}\n";
  }
}