import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  Future<String> get _localDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<LocalFile> getFile(String filename) async {
    final directory = await _localDirectory;
    return new LocalFile('$directory/$filename');
  }
}

class LocalFile {
  final String path;

  LocalFile(this.path);

  Future<bool> get exists async {
    final file = await _localFile;
    return file.exists();
  }

  Future<String> get contents async {
    final file = await _localFile;
    return file.readAsString();
  }

  Future<File> get _localFile async {
    return new File(path);
  }

  Future<Null> writeContents(String contents) async {
    final file = await _localFile;
    await file.writeAsString(contents);
  }
}
