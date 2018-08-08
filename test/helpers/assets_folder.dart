
import 'dart:io';

/// helps determine the assets folder depending on if a test is run from
/// the test class or from the project base folder
abstract class AssetsFolder {
  static String get path {
    final testPath = Platform.script.toFilePath();

    if(testPath.contains('\\test\\') || testPath.contains('/test/')) {
      return Platform.script.resolve('../assets/data').toFilePath();
    }
    return Platform.script.resolve('./assets/data').toFilePath();
  }
}