import 'package:travelconverter/helpers/sorting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sort helper correctly sorts alphabetically', () {
    final objects = <_TestObject>[
      _TestObject('ceasar'),
      _TestObject('Delta'),
      _TestObject('alpha'),
      _TestObject('beta')
    ];

    final sorted = alphabeticallySorted<_TestObject>(objects, (o) => o.value)
        .map((o) => o.value)
        .toList();

    expect(sorted, ['alpha', 'beta', 'ceasar', 'Delta']);
  });

  test('sort helper throws on invalid null list entry', () {
    final listWithInvalidEntry = <_TestObject?>[null, _TestObject('alpha')];
    expect(
        () => alphabeticallySorted<_TestObject?>(
            listWithInvalidEntry, (o) => o?.value),
        throwsA(isInstanceOf<ArgumentError>()));
  });

  test('sort helper throws on invalid null property', () {
    final listWithNullPropertyValue = <_TestObject>[
      _TestObject(null),
      _TestObject('alpha')
    ];

    expect(
        () => alphabeticallySorted<_TestObject>(
            listWithNullPropertyValue, (o) => o.value),
        throwsA(isInstanceOf<ArgumentError>()));
  });

  test('sort helper correctly throws on exceptions', () {
    expect(() => nonNull(null, 'name'), throwsA(isInstanceOf<ArgumentError>()));
    expect(() => assertNotNull(null, 'name'),
        throwsA(isInstanceOf<ArgumentError>()));
  });
}

class _TestObject {
  final String? value;

  _TestObject(this.value);
}
