import 'package:backpacking_currency_converter/helpers/sorting.dart';
import 'package:test/test.dart';

void main() {
  test('sort helper correctly sorts alphabetically', () {

    final objects = <_TestObject>[
      _TestObject('ceasar'),
      _TestObject('Delta'),
      _TestObject('alpha'),
      _TestObject('beta')
    ];

    final sorted = alphabeticallySorted(objects, (o) => o.value)
          .map((o) => o.value).toList();

    expect(sorted, ['alpha', 'beta', 'ceasar', 'Delta']);
  });

  test('sort helper correctly throws on exceptions', () {
    expect(() => alphabeticallySorted(null, null), throwsA(new isInstanceOf<ArgumentError>()));
    expect(() => nonNull(null, 'name'), throwsA(new isInstanceOf<ArgumentError>()));
    expect(() => assertNotNull(null, 'name'), throwsA(new isInstanceOf<ArgumentError>()));
  });
}

class _TestObject {
  final String value;

  _TestObject(this.value);
}
