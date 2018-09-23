import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelconverter/app_theme.dart';
import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/screens/convert/currency_convert_card.dart';
import 'package:travelconverter/state_container.dart';

class EditScreenListEntry extends StatefulWidget {
  final Currency currency;

  const EditScreenListEntry({Key key, Currency currency})
      : this.currency = currency,
        super(key: key);

  @override
  _EditScreenListEntryState createState() {
    return new _EditScreenListEntryState();
  }
}

class _EditScreenListEntryState extends State<EditScreenListEntry> {
  @override
  Widget build(BuildContext context) {
    final card = new Container(
      height: CurrencyConvertCard.height,
      child: new Material(
        color: Colors.transparent,
        child: Card(
            color: AppTheme.primaryColor,
            child: new InkWell(
              splashColor: AppTheme.accentColor,
              child: new Padding(
                  padding: const EdgeInsets.only(
                      top: 4.0, bottom: 4.0, left: 2.0, right: 10.0),
                  child: _cardContents),
            )),
      ),
    );

    return card;
  }

  get _cardContents {
    final name = AppLocalizations.of(context)
        .currencies
        .getLocalized(widget.currency.code);
    return new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Align(alignment: Alignment.centerLeft, child: _deleteIcon),
          Expanded(
              child: new Align(
                alignment: Alignment.centerLeft,
                child: Text(name, style: TextStyle(fontSize: 16.0)),
              )),
          new Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                _moveHandleIcon,
                size: 32.0,
              ))
        ]);
  }

  get _deleteIcon {
    return IconButton(
      padding: EdgeInsets.all(0.0),
      iconSize: 32.0,
      icon: Container(
          decoration:
          BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Icon(_removeIcon, color: AppTheme.deleteColour)),
      onPressed: () {
        StateContainer.of(context).removeCurrency(widget.currency.code);
      },
    );
  }

  IconData get _moveHandleIcon =>
      Platform.isAndroid ? Icons.drag_handle : _cupertinoDragHandle;

  IconData get _removeIcon =>
      Platform.isAndroid ? Icons.delete : _cupertinoDeleteCircle;

  // For some reason there aren't mapped in the CupertinoIcons class
  // See https://raw.githubusercontent.com/flutter/cupertino_icons/master/map.png
  IconData get _cupertinoDragHandle => IconData(0xf394,
      fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage);

  IconData get _cupertinoDeleteCircle => IconData(0xf464,
      fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage);

  String get currencyCode => widget.currency.code;
}