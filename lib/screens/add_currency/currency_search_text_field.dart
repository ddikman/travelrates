import 'package:backpacking_currency_converter/app_theme.dart';
import 'package:backpacking_currency_converter/model/country.dart';
import 'package:backpacking_currency_converter/model/currency.dart';
import 'package:flutter/material.dart';

class CurrencySearchTextField extends StatelessWidget {

  final ValueChanged<List<Currency>> filterChanged;
  final List<Currency> allCurrencies;
  final List<Country> countries;

  const CurrencySearchTextField({
    Key key,
    @required this.filterChanged,
    @required this.allCurrencies,
    @required this.countries
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    const hint = "Search country or currency code";

    final textField = TextField(
      autofocus: true,
      onChanged: _filterChanged,
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

  void _filterChanged(String filter) {

    filter = filter.toLowerCase();

    var filteredCurrencies = List.from(allCurrencies);

    if (filter.isNotEmpty) {
      final List<Country> matchingCountries = List.from(countries);
      matchingCountries.retainWhere(
              (country) => country.name.toLowerCase().contains(filter));

      allCurrencies.retainWhere((currency) {
        return currency.name.toLowerCase().contains(filter) ||
            currency.code.toLowerCase().contains(filter) ||
            matchingCountries
                .any((country) => country.currencyCode == currency.code);
      });
    }



    filterChanged(filteredCurrencies);
  }
}