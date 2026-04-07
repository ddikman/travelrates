import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/model/conversion_model.dart';
import 'package:travelconverter/model/country.dart';
import 'package:travelconverter/services/currency_repository.dart';
import 'package:travelconverter/services/legacy_currency_mapper.dart';

final appStateProvider =
    Provider<AppState>((ref) => throw Exception("Not initialized"));

class AppState {
  final ConversionModel conversion;

  final CurrencyRepository availableCurrencies;

  final List<Country> countries;

  final DateTime? ratesLastUpdated;

  const AppState(
      {required this.conversion,
      required this.availableCurrencies,
      required this.countries,
      this.ratesLastUpdated});

  AppState withConversion(ConversionModel conversion) {
    return AppState(
        conversion: conversion,
        availableCurrencies: availableCurrencies,
        countries: countries,
        ratesLastUpdated: ratesLastUpdated);
  }

  AppState withRatesLastUpdated(DateTime timestamp) {
    return AppState(
        conversion: conversion,
        availableCurrencies: availableCurrencies,
        countries: countries,
        ratesLastUpdated: timestamp);
  }

  Map<String, dynamic> toJson() => {
        'currentAmount': conversion.currentAmount,
        'currentCurrency': conversion.currentCurrency.code,
        'currencies': conversion.currencies,
        'ratesLastUpdated': ratesLastUpdated?.toIso8601String()
      };

  AppState.fromJson(Map<String, dynamic> json, this.availableCurrencies,
      this.countries)
      : conversion = ConversionModel(
            currentAmount: json['currentAmount'],
            currentCurrency: availableCurrencies.getByCode(
                LegacyCurrencyMapper.mapCode(json['currentCurrency'])),
            currencies: LegacyCurrencyMapper.mapCodes(
                List.castFrom(json['currencies']))),
        ratesLastUpdated = json['ratesLastUpdated'] != null
            ? DateTime.parse(json['ratesLastUpdated'])
            : null;

  AppState.initial(
      {required this.countries,
      required this.availableCurrencies})
      : conversion = ConversionModel(
            currentAmount: 1.0,
            currentCurrency: availableCurrencies.baseCurrency,
            currencies: <String>[]),
        ratesLastUpdated = null;
}
