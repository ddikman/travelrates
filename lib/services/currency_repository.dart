import 'package:backpacking_currency_converter/helpers/string_compare.dart';
import 'package:backpacking_currency_converter/model/currency.dart';

class CurrencyRepository {
  // TODO: encapsulate?
  final List<Currency> currencies;
  final String baseRate;

  CurrencyRepository({this.currencies, this.baseRate});

  Currency getBaseRateCurrency() => getCurrencyByCode(baseRate);

  Currency getCurrencyByCode(String code) {
    var matches = currencies.where((currency) => isEqualIgnoreCase(currency.code, code));
    if (matches.isEmpty) {
      print("Found no currency with code [$code] among ${currencies.length} currencies");
      throw StateError("No currency with code $code");
    }
    return matches.first;
  }

  List<Currency> getAllCurrencies() {
    return new List.from(currencies);
  }
}
