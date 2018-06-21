import 'dart:async';

import 'package:backpacking_currency_converter/app_routes.dart';
import 'package:backpacking_currency_converter/app_theme.dart';
import 'package:backpacking_currency_converter/widgets/background_container.dart';
import 'package:backpacking_currency_converter/model/country.dart';
import 'package:backpacking_currency_converter/model/currency.dart';
import 'package:backpacking_currency_converter/screens/convert/currency_convert_card.dart';
import 'package:backpacking_currency_converter/services/country_detector.dart';
import 'package:backpacking_currency_converter/state_container.dart';

import 'package:flutter/material.dart';

class ConvertScreen extends StatefulWidget {
  @override
  _ConvertScreenState createState() {
    return new _ConvertScreenState();
  }
}

class _ConvertScreenState extends State<ConvertScreen> {
  static const double _listViewSpacing = 12.0;
  static const double _floatingButtonSpacing = 60.0;
  static const int _msDelayBetweenItemAppearance = 100;

  // to get scaffold context and then snackbar
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  final CountryDetector _positionFinder = new CountryDetector();

  bool _performedCountryDetection = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (!_performedCountryDetection) {
      final state = StateContainer
          .of(context)
          .appState;

      final country = await _positionFinder.detectNewCountry(state.countries);
      await _addNewCountry(country);
      _performedCountryDetection = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = StateContainer
        .of(context)
        .appState;

    int index = 0;
    final cardWidgets = state.currencies
        .map((currency) => _buildCurrencyEntry(index++, currency))
        .toList();

    final cardListView = new ListView(
        padding: EdgeInsets.all(_listViewSpacing),
        children: cardWidgets
    );

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("CONVERT"),
          centerTitle: true,
          actions: <Widget>[_buildConfigureActionButton()],
        ),
        floatingActionButton: _buildAddCurrencyButton(),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        body: new BackgroundContainer(
          // padding the body bottom stops the floating space button from
          // hiding the lowermost content
            child: new Padding(
              padding: const EdgeInsets.only(bottom: _floatingButtonSpacing),
              child: cardListView,
            ))
    );
  }

  _buildConfigureActionButton() {
    final state = StateContainer
        .of(context)
        .appState;
    IconData displayIcon = state.isReconfiguring ? Icons.done : Icons.settings;

    return new IconButton(
        icon: Icon(displayIcon),
        onPressed: () {
          StateContainer.of(context).toggleIsReconfiguring();
        });
  }

  Widget _buildCurrencyEntry(int index, String currencyCode) {
    final state = StateContainer
        .of(context)
        .appState;

    final animationDelay =
    Duration(milliseconds: _msDelayBetweenItemAppearance * (index + 1));
    var currency = state.currencyRepo.getCurrencyByCode(currencyCode);
    final card = CurrencyConvertCard(
        currency: currency,
        onNewAmount: (value) {},
        animationDelay: animationDelay);

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

  Widget _withReorderDropArea(CurrencyConvertCard card) {
    final dropArea = new Align(
      alignment: Alignment.bottomCenter,
      child: new DragTarget<Currency>(
        builder: (BuildContext context, List candidateData, List rejectedData) {
          bool hovered = candidateData.isNotEmpty;
          return _dropTargetArea(hovered);
        },
        onAccept: (value) {
          // handle the reorder. since we dropped the other card on this card
          // it means we want to place it _after_ this card
          StateContainer
              .of(context)
              .reorder(item: value.code, placeAfter: card.currency.code);
        },
        onWillAccept: (value) => value.code != card.currency.code,
      ),
    );

    return Stack(
      children: <Widget>[card, dropArea],
    );
  }

  Widget _dropTargetArea(bool hovered) {
    const iconSize = 24.0;

    final dropAreaHeight = hovered
        ? (CurrencyConvertCard.height + iconSize)
        : CurrencyConvertCard.height;

    return new FractionallySizedBox(
      widthFactor: 1.0,
      child: Container(
        height: dropAreaHeight,
        alignment: Alignment.bottomCenter,
        child: Opacity(
          opacity: hovered ? 1.0 : 0.0,
          child: Icon(
            Icons.add_circle,
            color: AppTheme.primaryColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }

  Future<Null> _addNewCountry(CountryResult countryResult) async {
    if (!countryResult.successful) {
      return;
    }

    final country = countryResult.country;

    final stateContainer = StateContainer.of(context);
    final state = stateContainer.appState;
    if (state.currencies.contains(country.currencyCode)) {
      print("detected ${country.name} as current country, currency is already added.");
      return;
    }

    print("local currency '${country.currencyCode}' is missing, adding it..");
    stateContainer.addCurrency(country .currencyCode);
    final currency = state.currencyRepo.getCurrencyByCode(country .currencyCode);
    _notifyNewCurrencyAdded(country , currency);
  }

  void _notifyNewCurrencyAdded(Country country, Currency currency) {
    final tipDisplaySeconds = 10;

    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: Duration(seconds: tipDisplaySeconds),
      action: new SnackBarAction(
        label: 'Got it!', onPressed: () {
          // user just acknowledged info, no further action needed
      },
      ),
      content: Text(
          "Hey! Just noticed you're in ${country.name}, cool! I've added the local currency, ${currency.name} to the conversion list for you. Enjoy!"),
    ));
  }

}