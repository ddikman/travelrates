import 'package:backpacking_currency_converter/helpers/string_compare.dart';
import 'package:backpacking_currency_converter/model/currency.dart';
import 'package:backpacking_currency_converter/model/currency_rate.dart';
import 'package:backpacking_currency_converter/services/logger.dart';

class CurrencyRepository {

  static final log = new Logger<CurrencyRepository>();

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

  List<Currency> getList() => List.from(_currencies);

  get baseCurrency => getByCode(_baseRate);

  Currency getByCode(String code) {
    var matches = _currencies.where((currency) => isEqualIgnoreCase(currency.code, code));
    if (matches.isEmpty) {
      log.error("Found no currency with code [$code] among ${_currencies.length} currencies");
      throw StateError("No currency with code $code");
    }
    return matches.first;
  }

  void updateRates(List<CurrencyRate> rates) {
    rates.forEach((rate) => _update(rate.currencyCode, rate.rate));
  }

  void _update(String currencyCode, double newRate) {
    var matches = _currencies.where((currency) => isEqualIgnoreCase(currency.code, currencyCode));
    if (matches.isEmpty) {
      // for example ANG isn't represented in the currency list
      return;
    }
    matches.first.rate = newRate;
  }
}
