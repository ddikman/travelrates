import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tools/store_metadata_validator.dart';

void main() {
  test('store metadata and creatives are complete and valid', () {
    expect(validateStoreMetadata(Directory.current), isEmpty);
  });
}
