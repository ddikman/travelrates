
import 'package:travelconverter/model/country.dart';

abstract class MockCountry {

  static Country get america => new Country('United States', 'US', 'USD');
  static Country get britain => new Country('Great Britain', 'gb', 'GBP');
  static Country get germany => new Country('Germany', 'de', 'EUR');

  static List<Country> get all => [
    america, britain, germany
  ];
}