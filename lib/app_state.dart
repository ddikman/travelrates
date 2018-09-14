import 'package:travelconverter/model/conversion_model.dart';
import 'package:travelconverter/model/country.dart';
import 'package:travelconverter/services/currency_repository.dart';
import 'package:flutter/foundation.dart';

class AppState {
  final _AppMode _mode;

  final ConversionModel conversion;

  final CurrencyRepository availableCurrencies;

  final List<Country> countries;

  bool get isEditing => _mode == _AppMode.editing;

  const AppState(
      {@required _AppMode mode,
      @required ConversionModel conversion,
      @required CurrencyRepository availableCurrencies,
      @required List<Country> countries})
      : this._mode = mode,
        this.conversion = conversion,
        this.countries = countries,
        this.availableCurrencies = availableCurrencies;

  AppState withConversion(ConversionModel conversion) {
    return new AppState(
        conversion: conversion,
        availableCurrencies: this.availableCurrencies,
        mode: this._mode,
        countries: this.countries);
  }

  Map<String, dynamic> toJson() => {
        'currentAmount': conversion.currentAmount,
        'currentCurrency': conversion.currentCurrency.code,
        'currencies': conversion.currencies
      };

  AppState.fromJson(Map<String, dynamic> json, CurrencyRepository repository,
      List<Country> countries)
      : this.availableCurrencies = repository,
        this._mode = _AppMode.ready,
        this.conversion = new ConversionModel(
            currentAmount: json['currentAmount'],
            currentCurrency: repository.getByCode(json['currentCurrency']),
            currencies: List.castFrom(json['currencies'])),
        this.countries = countries;

  AppState withMode(_AppMode mode) {
    return new AppState(
        conversion: this.conversion,
        availableCurrencies: this.availableCurrencies,
        countries: this.countries,
        mode: mode);
  }

  AppState startEdit() {
    return this.withMode(_AppMode.editing);
  }

  AppState stopEdit() {
    return this.withMode(_AppMode.ready);
  }

  AppState.initial(
      {List<Country> countries, CurrencyRepository availableCurrencies})
      : this.availableCurrencies = availableCurrencies,
        this._mode = _AppMode.ready,
        this.countries = countries,
        this.conversion = new ConversionModel(
            currentAmount: 1.0,
            currentCurrency: availableCurrencies.baseCurrency,
            currencies: new List<String>());
}

/// Specifies the applications current mode
enum _AppMode { editing, ready }
