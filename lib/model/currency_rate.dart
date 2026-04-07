class CurrencyRate {
  final String _currencyCode;

  final double _rate;

  CurrencyRate(String currencyCode, double rate)
      : _currencyCode = currencyCode,
        _rate = rate;

  String get currencyCode => _currencyCode;

  double get rate => _rate;
}
