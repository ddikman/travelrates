import 'dart:convert';

import 'package:flutter/services.dart';

class TestAssetBundle extends CachingAssetBundle {
  final _data = <String, String>{};

  void set(String key, String data) {
    _data[key] = data;
  }

  @override
  Future<ByteData> load(String key) {
    if (!_data.containsKey(key)) {
      throw Exception("Missing any mocked asset with path '$key'");
    }

    return Future<ByteData>.value(
        ByteData.view(Uint8List.fromList(utf8.encode(_data[key]!)).buffer));
  }
}
