
class Country {

  final String name;

  final String code;

  final String currencyCode;

  const Country(this.name, this.code, this.currencyCode);

  Country.fromJson(dynamic json) :
      this.name = json['name'],
      this.code = json['code'],
      this.currencyCode = json['currency'];
}