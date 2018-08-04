class CurrencyRate {
  final String _currencyCode;

  final double _rate;

  CurrencyRate(String currencyCode, double rate)
      : this._currencyCode = currencyCode,
        this._rate = rate;

  String get currencyCode => _currencyCode;

  double get rate => _rate;
}
