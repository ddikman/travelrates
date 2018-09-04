import 'package:moneyconverter/model/currency.dart';

abstract class MockCurrency {
  static Currency get dollar => new Currency(
      symbol: "\$",
      name: "United States Dollar",
      code: "USD",
      icon: "USD",
      rate: 1.169);

  static Currency get euro => new Currency(
      name: "Euro", code: "EUR", icon: "EUR", symbol: '€', rate: 1.0);

  static Currency get pound => new Currency(
      name: "British Pound Sterling",
      code: "GBP",
      icon: "GBP",
      symbol: "£",
      rate: 0.88);
}
