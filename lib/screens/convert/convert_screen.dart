import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:travelconverter/screens/convert/open_add_currency_screen_button.dart';
import 'package:travelconverter/screens/convert/selected_currency_list.dart';
import 'package:travelconverter/screens/convert/goto_configure_button.dart';
import 'package:travelconverter/screens/convert/settings_button.dart';
import 'package:travelconverter/screens/review_feature/review_storage.dart';
import 'package:travelconverter/screens/review_feature/review_widget.dart';
import 'package:travelconverter/services/local_storage.dart';
import 'package:travelconverter/widgets/background_container.dart';

import 'package:flutter/material.dart';
import 'package:travelconverter/widgets/screen_title_text.dart';

import '../../internet_connectivity.dart';

class ConvertScreen extends StatefulWidget {

  static String get screenTitle => Intl.message(
      "Convert",
      name: "ConvertScreen_screenTitle",
      desc: "Convert screen main title"
  );

  @override
  _ConvertScreenState createState() {
    return new _ConvertScreenState();
  }
}

class _ConvertScreenState extends State<ConvertScreen> {
  // Keep a key for scaffold to use when showing snackbar
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    final appBar = new AppBar(
      title: ScreenTitleText.show(ConvertScreen.screenTitle),
      centerTitle: true,
      actions: [ new GotoConfigureButton() ],
      leading: SettingsButton(),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: _buildCurrencyList(),
      floatingActionButton: new OpenAddCurrencyScreenButton(),
    );
  }

  _buildCurrencyList() {
    const _floatingButtonSpacing = 60.0;

    return new BackgroundContainer(
        key: Key("ConvertScreen"),
        // padding the body bottom stops the floating space button from
        // hiding the lowermost content
        child: new Padding(
        padding: const EdgeInsets.only(bottom: _floatingButtonSpacing),
        child: new Builder(builder: (BuildContext context) {
          return new ReviewWidget(
            child: new SelectedCurrencyList(),
            reviewStorage: new ReviewStorage(new InternetConnectivityImpl(new Connectivity()), new LocalStorage()),
          );
        }),
    ));
  }
}
