import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/model/conversion_model.dart';
import 'package:travelconverter/model/country.dart';
import 'package:travelconverter/services/currency_repository.dart';

final appStateProvider =
    Provider<AppState>((ref) => throw Exception("Not initialized"));

class AppState {
  final ConversionModel conversion;

  final CurrencyRepository availableCurrencies;

  final List<Country> countries;

  const AppState(
      {required ConversionModel conversion,
      required CurrencyRepository availableCurrencies,
      required List<Country> countries})
      : this.conversion = conversion,
        this.countries = countries,
        this.availableCurrencies = availableCurrencies;

  AppState withConversion(ConversionModel conversion) {
    return new AppState(
        conversion: conversion,
        availableCurrencies: this.availableCurrencies,
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
        this.conversion = new ConversionModel(
            currentAmount: json['currentAmount'],
            currentCurrency: repository.getByCode(json['currentCurrency']),
            currencies: List.castFrom(json['currencies'])),
        this.countries = countries;

  AppState.initial(
      {required List<Country> countries,
      required CurrencyRepository availableCurrencies})
      : this.availableCurrencies = availableCurrencies,
        this.countries = countries,
        this.conversion = new ConversionModel(
            currentAmount: 1.0,
            currentCurrency: availableCurrencies.baseCurrency,
            currencies: <String>[]);
}
