import 'package:moneyconverter/model/currency_rate.dart';
import 'package:test/test.dart';
import 'mocks/mock_currency_repository.dart';

void main() {

  final repository = mockCurrencyRepository();

  test('when requesting missing currency throws state error', () {
    expect(() => repository.getByCode('MISSING'),
        throwsA(new isInstanceOf<StateError>()));
  });

  test('allows new rates to be set', () {
    final rateBefore = repository.getByCode('USD').rate;
    final newRate = new CurrencyRate('USD', rateBefore + 1);
    repository.updateRates(<CurrencyRate>[newRate]);
    expect(repository.getByCode('USD').rate, newRate.rate);
  });

  test('silently ignores unsupported currency rates', () {
    final unknownCurrency = new CurrencyRate('XXX', 1.0);
    repository.updateRates(<CurrencyRate>[unknownCurrency]);
  });
}
