import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/l10n/app_localizations.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:travelconverter/use_cases/view_rates/ui/compare_currency_card.dart';
import 'package:travelconverter/state_container.dart';

class EditScreenListEntry extends StatefulWidget {
  final Currency currency;

  const EditScreenListEntry({Key? key, required Currency currency})
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
      height: CompareCurrencyCard.height,
      child: new Material(
        color: Colors.transparent,
        child: Card(
            color: lightTheme.backgroundSecondary,
            child: new InkWell(
              splashColor: lightTheme.background,
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
    final decoration = Platform.isAndroid
        ? null
        : BoxDecoration(shape: BoxShape.circle, color: Colors.white);

    return IconButton(
      padding: EdgeInsets.all(0.0),
      iconSize: 32.0,
      icon: Container(
          decoration: decoration,
          child: Icon(_removeIcon, color: lightTheme.red)),
      onPressed: () {
        StateContainer.of(context).removeCurrency(widget.currency.code);
      },
    );
  }

  IconData get _moveHandleIcon =>
      Platform.isAndroid ? Icons.drag_handle : CupertinoIcons.line_horizontal_3;

  IconData get _removeIcon =>
      Platform.isAndroid ? Icons.delete : CupertinoIcons.clear_circled_solid;

  String get currencyCode => widget.currency.code;
}
