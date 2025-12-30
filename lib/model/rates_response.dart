import 'package:travelconverter/model/currency_rate.dart';

class RatesResponse {
  final List<CurrencyRate> rates;
  final DateTime? timestamp;

  RatesResponse({required this.rates, this.timestamp});
}
