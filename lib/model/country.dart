
class Country {

  final String name;

  final String code;

  final String currencyCode;

  const Country(this.name, this.code, this.currencyCode);

  Country.fromJson(dynamic json) :
      name = json['name'],
      code = json['code'],
      currencyCode = json['currency'];
}