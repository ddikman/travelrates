import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:travelconverter/model/api_configuration.dart';
import 'package:travelconverter/services/rates_api.dart';

import '../helpers/assets_folder.dart';

void main() {
  group('RatesApi', () {
    test("skips download of rates if offline", () async {
      final api = RatesApi(MockConfig());
      api.connectivity = MockConnectivity([ConnectivityResult.none]);

      final result = await api.getCurrentRatesJson();
      expect(result.successful, false);
    });

    test("returns failure if server does not respond correctly", () async {
      final api = RatesApi(MockConfig());
      api.connectivity = MockConnectivity([ConnectivityResult.wifi]);
      api.client = MockClient(() => Response("", 500));

      final result = await api.getCurrentRatesJson();
      expect(result.successful, false);
    });

    test("returns failure on exception", () async {
      final api = RatesApi(MockConfig());
      api.connectivity = MockConnectivity([ConnectivityResult.wifi]);
      api.client = MockClient(() => throw Exception("Mock failure"));

      final result = await api.getCurrentRatesJson();
      expect(result.successful, false);
    });

    test("can read from actual service", () async {
      final assets = await AssetsFolder.path;
      final assetPath = '$assets/data/apiConfiguration.json';
      final configFile = File(assetPath);
      if (!configFile.existsSync() || configFile.readAsStringSync().trim().isEmpty) {
        markTestSkipped('apiConfiguration.json not available');
        return;
      }
      // ignore: avoid_print
      print("reading configuration from $assetPath");
      final apiConfigJson = await configFile.readAsString();
      final apiConfig =
          ApiConfiguration.fromJson(json.decode(apiConfigJson.trim()));
      final api = RatesApi(apiConfig);
      api.connectivity = MockConnectivity([ConnectivityResult.wifi]);

      final result = await api.getCurrentRatesJson();
      expect(result.successful, true);
    });
  });
}

class MockClient implements Client {
  final Function _response;

  MockClient(Function response) : _response = response;

  @override
  void close() {
    throw UnimplementedError();
  }

  Future<Response> _generateResponse() {
    return Future.value(_response());
  }

  @override
  Future<Response> get(url, {Map<String, String>? headers}) {
    return _generateResponse();
  }

  @override
  Future<Response> head(url, {Map<String, String>? headers}) {
    return _generateResponse();
  }

  @override
  Future<Response> patch(url,
      {Map<String, String>? headers, body, Encoding? encoding}) {
    return _generateResponse();
  }

  @override
  Future<Response> post(url,
      {Map<String, String>? headers, body, Encoding? encoding}) {
    return _generateResponse();
  }

  @override
  Future<Response> put(url,
      {Map<String, String>? headers, body, Encoding? encoding}) {
    return _generateResponse();
  }

  @override
  Future<String> read(url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readBytes(url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _generateResponse();
  }
}

class MockConnectivity implements Connectivity {
  final List<ConnectivityResult> connectivityResult;

  MockConnectivity(this.connectivityResult);

  @override
  Future<List<ConnectivityResult>> checkConnectivity() {
    return Future.value(connectivityResult);
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      Stream<List<ConnectivityResult>>.empty();
}

class MockConfig implements ApiConfiguration {
  @override
  String get apiKey => "apiKey";

  @override
  String get apiUrl => "apiUrl";
}
