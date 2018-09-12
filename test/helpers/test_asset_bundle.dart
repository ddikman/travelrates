import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'assets_folder.dart';

/// A wrapper for assets to allow us to read them using the default bundle in tests.
class TestAssetBundle extends CachingAssetBundle {

  @override
  Future<String> loadString(String key, {bool cache: true}) async {
    var assetsPath = await AssetsFolder.path;
    assetsPath = key.replaceAll('assets/', assetsPath);
    return await new File(assetsPath).readAsString();
  }

  @override
  Future<ByteData> load(String key) async {
    final data = await loadString(key);
    return new ByteData.view(new Uint8List.fromList(utf8.encode(data)).buffer);
  }
}