
import 'package:travelconverter/model/country.dart';

abstract class MockCountry {

  static Country get america => Country('United States', 'US', 'USD');
  static Country get britain => Country('Great Britain', 'gb', 'GBP');
  static Country get germany => Country('Germany', 'de', 'EUR');

  static List<Country> get all => [
    america, britain, germany
  ];
}