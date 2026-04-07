import 'package:travelconverter/model/currency.dart';

abstract class MockCurrency {
  static Currency get dollar => Currency(
      symbol: "\$",
      name: "United States Dollar",
      code: "USD",
      icon: "US",
      rate: 1.169);

  static Currency get euro => Currency(
      name: "Euro", code: "EUR", icon: "EU", symbol: '€', rate: 1.0);

  static Currency get pound => Currency(
      name: "British Pound Sterling",
      code: "GBP",
      icon: "GB",
      symbol: "£",
      rate: 0.88);
}
