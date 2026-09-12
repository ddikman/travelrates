import 'dart:io';

import 'store_metadata_validator.dart';

void main() {
  final errors = validateStoreMetadata(Directory.current);
  if (errors.isEmpty) {
    stdout.writeln('Store metadata and creatives are valid.');
    return;
  }

  stderr.writeln('Store validation failed:');
  for (final error in errors) {
    stderr.writeln('- $error');
  }
  exitCode = 1;
}
