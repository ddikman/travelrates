import 'package:backpacking_currency_converter/app_routes.dart';
import 'package:backpacking_currency_converter/app_theme.dart';
import 'package:backpacking_currency_converter/background_container.dart';
import 'package:backpacking_currency_converter/currency.dart';
import 'package:backpacking_currency_converter/currency_convert_card.dart';
import 'package:backpacking_currency_converter/position_finder.dart';
import 'package:backpacking_currency_converter/state_container.dart';

import 'package:flutter/material.dart';

class ConvertScreen extends StatefulWidget {
  @override
  _ConvertScreenState createState() {
    return new _ConvertScreenState();
  }
}

class _ConvertScreenState extends State<ConvertScreen> {

  static const _listViewSpacing = 12.0;
  static const _floatingButtonSpacing = 60.0;

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context).appState;

    int index = 0;
    final cards = new Material(
      color: Colors.transparent,
      child: new Padding(
        padding: const EdgeInsets.only(bottom: _floatingButtonSpacing),
        // add space for float button
        child: new ListView(
          padding: EdgeInsets.all(_listViewSpacing),
          children: state.currencies
              .map((currency) => _buildCard(index++, currency))
              .toList(),
        ),
      ),
    );

    final body = new PositionFinder(
        child: new Container(color: Colors.transparent, child: cards));

    return Scaffold(
        appBar: AppBar(
          title: Text("How much is.."),
          actions: <Widget>[_buildConfigureActionButton()],
        ),
        floatingActionButton: _buildAddCurrencyButton(),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        body: new BackgroundContainer(child: body));
  }

  Widget _buildCard(int index, String currencyCode) {
    final state = StateContainer.of(context).appState;

    var currency = state.currencyRepo.getCurrencyByCode(currencyCode);
    final card = CurrencyConvertCard(
        currency: currency,
        onNewAmount: (value) {},
        index: index);

    return _withReorderDropArea(card);
  }

  _buildAddCurrencyButton() {
    final floatingButton = FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pushNamed(AppRoutes.addCurrency);
      },
    );

    return floatingButton;
  }

  _buildConfigureActionButton() {
    final state = StateContainer.of(context).appState;
    IconData displayIcon = state.isReconfiguring ? Icons.done : Icons.settings;

    return new IconButton(
        icon: Icon(displayIcon),
        onPressed: () {
          StateContainer.of(context).toggleIsReconfiguring();
        });
  }

  Widget _withReorderDropArea(CurrencyConvertCard card) {

    const iconSize = 24.0;
    final dropArea = new Align(
      alignment: Alignment.bottomCenter,
      child: new DragTarget<Currency>(
        builder: (BuildContext context, List candidateData, List rejectedData) {
          bool hovered = candidateData.isNotEmpty;
          final dropAreaHeight = hovered ? (CurrencyConvertCard.height + iconSize) : CurrencyConvertCard.height;
          return new FractionallySizedBox(
            widthFactor: 1.0,
            child: Container(
              height: dropAreaHeight,
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: hovered ? 1.0 : 0.0,
                child: Icon(
                  Icons.add_circle,
                  color: AppTheme.accentColor,
                  size: 24.0,
                ),
              ),
            ),
          );
        },
        onAccept: (value) {
          // handle the reorder. since we dropped the other card on this card
          // it means we want to place it _after_ this card
          StateContainer.of(context).reorder(
            item: value.code,
            placeAfter: card.currency.code
          );
        },
        onWillAccept: (value) => value.code != card.currency.code,
      ),
    );

    return Stack(
      children: <Widget>[
        card,
        dropArea
      ],
    );
  }
}


