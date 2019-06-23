
import 'package:travelconverter/services/local_storage.dart';

class MockLocalStorage extends LocalStorage {

  final _files = new Map<String, MockLocalFile>();

  setFile(String filename, String contents) {
    _files[filename] = new MockLocalFile(filename, true, contents);
  }

  @override
  Future<FileOperations> getFile(String filename) {
    if (_files.containsKey(filename)) {
      return Future<FileOperations>.value(_files[filename]);
    }

    var localFile = new MockLocalFile(filename, false, null);
    _files[filename] = localFile;
    return Future<FileOperations>.value(localFile);
  }
}

class MockLocalFile implements FileOperations {
  String currentContents;

  bool fileExists;

  MockLocalFile(String path, bool exists, String contents) :
        this.currentContents = contents,
        this.fileExists = exists;

  @override
  Future<bool> get exists {
    return Future.value(this.fileExists);
  }

  @override
  Future<Null> writeContents(String contents) {
    this.currentContents = contents;
    this.fileExists = true;
    return Future.value(null);
  }

  @override
  Future<String> get contents {
    return Future.value(this.currentContents);
  }

}