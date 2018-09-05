
import 'dart:async';
import 'dart:io';

/// helps determine the assets folder depending on if a test is run from
/// the test class or from the project base folder
abstract class AssetsFolder {
  static Future<String> get path async {
    if(await _inParentFolder.exists()) {
      return _inParentFolder.path;
    }

    // if not in the parent folder, then it should be in the current script folder
    // this happens when we run a test directly from the IDE
    if (await _inBaseFolder.exists()) {
      return _inBaseFolder.path;
    }

    throw StateError('Failed to find the asset folder, something might have changed');
  }

  static Directory get _inParentFolder => _getDirectory('../assets');

  static Directory get _inBaseFolder => _getDirectory('./assets');

  static Directory _getDirectory(String relative) {
    return new Directory(Platform.script.resolve(relative).toFilePath());
  }
}