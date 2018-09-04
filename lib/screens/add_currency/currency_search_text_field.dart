import 'package:moneyconverter/app_theme.dart';
import 'package:moneyconverter/model/currency.dart';
import 'package:flutter/material.dart';

typedef void CurrenciesChanged(List<Currency> currencies);

class CurrencySearchTextField extends StatefulWidget {

  final ValueChanged<String> filterChanged;

  const CurrencySearchTextField({
    Key key,
    @required this.filterChanged,
  }) : super(key: key);

  @override
  CurrencySearchTextFieldState createState() {
    return new CurrencySearchTextFieldState();
  }
}

class CurrencySearchTextFieldState extends State<CurrencySearchTextField> {

  @override
  Widget build(BuildContext context) {

    const hint = "Search country or currency code";

    final textField = TextField(
      autofocus: true,
      onChanged: widget.filterChanged,
      style: TextStyle(color: AppTheme.primaryColor),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(4.0),
          hintText: hint,
          labelText: hint,
          labelStyle: Theme.of(context).textTheme.display1
              .copyWith(
              fontSize: 14.0,
              color: AppTheme.primaryColor
          ),
          border: InputBorder.none),
    );

    return new Padding(
      padding: EdgeInsets.all(14.0),
      child: new Container(
        padding: new EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: AppTheme.accentColor,
          borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
        ),
        child: textField,
      ),
    );
  }
}