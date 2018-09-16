
import 'package:intl/intl.dart';
import 'package:travelconverter/screens/convert/open_add_currency_screen_button.dart';
import 'package:travelconverter/screens/convert/selected_currency_list.dart';
import 'package:travelconverter/screens/convert/toggle_configure_button.dart';
import 'package:travelconverter/services/logger.dart';
import 'package:travelconverter/services/state_loader.dart';
import 'package:travelconverter/widgets/background_container.dart';

import 'package:flutter/material.dart';

class ConvertScreen extends StatefulWidget {

  final StateLoader stateLoader;

  const ConvertScreen({Key key, this.stateLoader}) : super(key: key);

  @override
  _ConvertScreenState createState() {
    return new _ConvertScreenState();
  }
}

class _ConvertScreenState extends State<ConvertScreen> {
  // Keep a key for scaffold to use when showing snackbar
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  static final log = new Logger<_ConvertScreenState>();

  @override
  Widget build(BuildContext context) {

    final appBar = new AppBar(
      title: new Text(_screenTitle),
      centerTitle: true,
      actions: [ new ToggleConfigureButton() ],
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: _buildCurrencyList(),
      floatingActionButton: new OpenAddCurrencyScreenButton(),
    );
  }

  String get _screenTitle => Intl.message(
      "CONVERT", desc: "Convert screen main title"
  );

  _buildCurrencyList() {
    const _floatingButtonSpacing = 60.0;

    return new BackgroundContainer(
        // padding the body bottom stops the floating space button from
        // hiding the lowermost content
        child: new Padding(
      padding: const EdgeInsets.only(bottom: _floatingButtonSpacing),
      child: new SelectedCurrencyList(),
    ));
  }
}
