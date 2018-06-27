import 'package:backpacking_currency_converter/helpers/string_compare.dart';
import 'package:backpacking_currency_converter/model/currency.dart';

class CurrencyRepository {

  final List<Currency> _currencies;

  final String _baseRate;

  CurrencyRepository({List<Currency> currencies, String baseRate})
  : _currencies = currencies,
    _baseRate = baseRate {
    assert(_currencies != null);
    assert(_currencies.isNotEmpty);
    assert(_baseRate != null);
    assert(_currencies.any((currency) => isEqualIgnoreCase(currency.code, _baseRate)));
  }

  List<Currency> get currencies => List.from(_currencies);

  Currency getBaseRateCurrency() => getCurrencyByCode(_baseRate);

  Currency getCurrencyByCode(String code) {
    var matches = _currencies.where((currency) => isEqualIgnoreCase(currency.code, code));
    if (matches.isEmpty) {
      print("Found no currency with code [$code] among ${_currencies.length} currencies");
      throw StateError("No currency with code $code");
    }
    return matches.first;
  }
}
