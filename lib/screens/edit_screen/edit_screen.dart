import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:travelconverter/app_theme.dart';
import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/screens/convert/currency_convert_card.dart';
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
      body: _buildBody(),
    );
  }

  String get _screenTitle => Intl.message(
    "Edit",
    desc: "Title for screen editing currency list"
  );

  _buildBody() {
    const _floatingButtonSpacing = 60.0;

    return new BackgroundContainer(
      // padding the body bottom stops the floating space button from
      // hiding the lowermost content
        child: new Padding(
          padding: const EdgeInsets.only(bottom: _floatingButtonSpacing),
          child: _buildCurrencyList(),
        ));
  }

  _buildCurrencyList() {
    final state = StateContainer
        .of(context)
        .appState;

    int index = 0;
    final currencies = state.conversion.currencies
        .map((currency) => _buildCurrencyEntry(context, index++, currency))
        .toList();

    return new ListView(
        padding: EdgeInsets.all(8.0),
        children: currencies
    );
  }

  Widget _buildCurrencyEntry(BuildContext context, int index, currencyCode) {
    final state = StateContainer
        .of(context)
        .appState;

    var currency = state.availableCurrencies.getByCode(currencyCode);
    final card = _buildCard(currency);

    return _withReorderDropArea(card, context);
  }

  _buildCard(Currency currency) {
    return new ReorderableCurrencyCard(currency: currency);
  }



  Widget _dropTargetArea(bool hovered, BuildContext context) {
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

  Widget _withReorderDropArea(ReorderableCurrencyCard card, BuildContext context) {
    final dropArea = new Align(
      alignment: Alignment.bottomCenter,
      child: new DragTarget<Currency>(
        builder: (BuildContext context, List candidateData, List rejectedData) {
          bool hovered = candidateData.isNotEmpty;
          return _dropTargetArea(hovered, context);
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
}

class ReorderableCurrencyCard extends StatefulWidget {

  final Currency currency;

  const ReorderableCurrencyCard({Key key, Currency currency}) : this.currency = currency, super(key: key);

  @override
  ReorderableCurrencyCardState createState() {
    return new ReorderableCurrencyCardState();
  }
}

class ReorderableCurrencyCardState extends State<ReorderableCurrencyCard> {
  @override
  Widget build(BuildContext context) {
    final card = new Container(
      padding: EdgeInsets.only(bottom: 4.0),
      height: CurrencyConvertCard.height,
      child: new Material(
        color: Colors.transparent,
        child: Card(
            color: AppTheme.primaryColor,
            child: new InkWell(
              splashColor: AppTheme.accentColor,
              child: new Padding(
                  padding: const EdgeInsets.only(
                    top: 4.0,
                    bottom: 4.0,
                    left: 2.0,
                    right: 10.0
                  ),
                  child: _cardContents),
            )),
      ),
    );

    return _asDraggable(card);
  }

  Widget _asDraggable(Widget child) {
    final screenWidth = MediaQuery.of(context).size.width;
    return new Draggable(
        data: widget.currency,
        affinity: Axis.vertical,
        child: child,
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: child,
        ),
        feedback: new Opacity(
          opacity: 0.8,
          child: new Container(
            width: screenWidth - 16.0 * 2,
            child: Card(
              color: AppTheme.primaryColor,
              child: Center(
                  child: new Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('${widget.currency.name}',
                        style: TextStyle(color: AppTheme.accentColor)),
                  )),
            ),
          ),
        ));
  }

  get _cardContents {
    final name = AppLocalizations.of(context).currencies.getLocalized(widget.currency.code);
    return new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Align(
              alignment: Alignment.centerLeft,
              child: _deleteIcon
          ),
          Expanded(child: new Align(
            alignment: Alignment.centerLeft,
            child: Text(name, style: TextStyle(fontSize: 16.0)),
          )),
          new Align(
              alignment: Alignment.centerLeft,
              child: Icon(_moveHandleIcon, size: 32.0,)
          )
        ]);
  }

  get _deleteIcon {
    return IconButton(
      padding: EdgeInsets.all(0.0),
      iconSize: 32.0,
      icon: Center(child: Icon(_removeIcon, color: AppTheme.accentColorLight)),
      onPressed: () {
        StateContainer.of(context).removeCurrency(widget.currency.code);
      },
    );
  }

  IconData get _moveHandleIcon => Platform.isAndroid ? Icons.drag_handle : _cupertinoDragHandle;
  IconData get _removeIcon => Platform.isAndroid ? Icons.delete : _cupertinoDeleteCircle;

  // For some reason there aren't mapped in the CupertinoIcons class
  // See https://raw.githubusercontent.com/flutter/cupertino_icons/master/map.png
  IconData get _cupertinoDragHandle => IconData(0xf394, fontFamily: CupertinoIcons.iconFont, fontPackage: CupertinoIcons.iconFontPackage);
  IconData get _cupertinoDeleteCircle => IconData(0xf464, fontFamily: CupertinoIcons.iconFont, fontPackage: CupertinoIcons.iconFontPackage);

  String get currencyCode => widget.currency.code;
}