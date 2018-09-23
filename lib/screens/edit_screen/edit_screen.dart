
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:travelconverter/screens/edit_screen/edit_screen_list_entry.dart';
import 'package:travelconverter/state_container.dart';
import 'package:travelconverter/widgets/background_container.dart';
import 'package:travelconverter/widgets/screen_title_text.dart';

class EditScreen extends StatefulWidget {
  @override
  EditScreenState createState() {
    return new EditScreenState();
  }
}

class EditScreenState extends State<EditScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final appBar = new AppBar(
      title: ScreenTitleText.show(_screenTitle),
      centerTitle: true,
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: new BackgroundContainer(child: _buildCurrencyList()),
    );
  }

  String get _screenTitle =>
      Intl.message("Edit", desc: "Title for screen editing currency list");

  _buildCurrencyList() {
    final stateContainer = StateContainer.of(context);
    final state = stateContainer.appState;

    final currencies = state.conversion.currencies
        .map(state.availableCurrencies.getByCode)
        .map((currency) => new EditScreenListEntry(
            key: Key(currency.code), currency: currency))
        .toList();

    // The ReorderableListView is flutter standard and has a long-press reorder capability
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new ReorderableListView(
        padding: EdgeInsets.only(bottom: 4.0),
        children: currencies,
        onReorder: _reorderListEntry
      ),
    );
  }

  void _reorderListEntry(int oldIndex, int newIndex) {
    final stateContainer = StateContainer.of(context);
    final state = stateContainer.appState;

      var moveCurrency = state.conversion.currencies.elementAt(oldIndex);
      stateContainer.reorderCurrency(
          item: moveCurrency, newIndex: newIndex);
    }
}