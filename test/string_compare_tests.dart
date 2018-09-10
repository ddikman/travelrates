import 'package:moneyconverter/helpers/string_compare.dart';
import 'package:test/test.dart';

void main() {
  test('can equal case insensitive', () {
    expect(isEqualIgnoreCase("BOB", "bob"), true);
    expect(isEqualIgnoreCase("bob", "BOB"), true);
    expect(isEqualIgnoreCase("b0B", "B0b"), true);

    expect(isEqualIgnoreCase("boc", "bob"), false);
    expect(isEqualIgnoreCase("B0B", "b0c"), false);
  });

  test('can compare case insensitive', () {
    expect(compareIgnoreCase("BOB", "cat"), "BOB".compareTo("CAT"));
  });

  test('can test contains case insensitive', () {
    expect(containsIgnoreCase("BOBCAT", "cat"), true);
    expect(containsIgnoreCase("BOBCAT", "bob"), true);
    expect(containsIgnoreCase("bobcat", "CAT"), true);
    expect(containsIgnoreCase("bobcat", "BOB"), true);
    expect(containsIgnoreCase("bobcatjones", "CAT"), true);
    expect(containsIgnoreCase("BOBCATJONES", "cat"), true);
  });
}
