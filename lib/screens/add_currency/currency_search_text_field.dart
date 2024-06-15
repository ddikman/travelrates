import 'package:intl/intl.dart';
import 'package:travelconverter/app_core/theme/colors.dart';
import 'package:travelconverter/model/currency.dart';
import 'package:flutter/material.dart';

typedef void CurrenciesChanged(List<Currency> currencies);

class CurrencySearchTextField extends StatefulWidget {
  final ValueChanged<String> filterChanged;

  const CurrencySearchTextField({
    Key? key,
    required this.filterChanged,
  }) : super(key: key);

  @override
  CurrencySearchTextFieldState createState() {
    return new CurrencySearchTextFieldState();
  }
}

class CurrencySearchTextFieldState extends State<CurrencySearchTextField> {
  @override
  Widget build(BuildContext context) {
    final textField = TextField(
      autofocus: true,
      onChanged: widget.filterChanged,
      style: TextStyle(color: lightTheme.text),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(4.0),
          hintText: _hint,
          labelText: _hint,
          labelStyle: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontSize: 14.0, color: lightTheme.text),
          border: InputBorder.none),
    );

    return new Padding(
      padding: EdgeInsets.all(14.0),
      child: new Container(
        padding: new EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: lightTheme.backgroundSecondary,
          borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
        ),
        child: textField,
      ),
    );
  }

  String get _hint => Intl.message("Search country or currency code",
      desc: "Help text above currency search field.");
}
