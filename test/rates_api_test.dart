import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:travelconverter/model/api_configuration.dart';
import 'package:travelconverter/services/rates_api.dart';

import 'helpers/assets_folder.dart';

void main() {
  test("skips download of rates if offline", () async {
    final api = new RatesApi(new MockConfig());
    api.connectivity = new MockConnectivity(ConnectivityResult.none);

    final result = await api.getCurrentRatesJson();
    expect(result.successful, false);
  });

  test("returns failure if server does not respond correctly", () async {
    final api = new RatesApi(new MockConfig());
    api.connectivity = new MockConnectivity(ConnectivityResult.wifi);
    api.client = new MockClient(() => new Response("", 500));

    final result = await api.getCurrentRatesJson();
    expect(result.successful, false);
  });

  test("returns failure on exception", () async {
    final api = new RatesApi(new MockConfig());
    api.connectivity = new MockConnectivity(ConnectivityResult.wifi);
    api.client = new MockClient(() => throw new Exception("Mock failure"));

    final result = await api.getCurrentRatesJson();
    expect(result.successful, false);
  });

  test("can read from actual service", () async  {
    final assets = await AssetsFolder.path;
    final assetPath = '$assets/data/apiConfiguration.json';
    print("reading configuration from $assetPath}");
    final apiConfigJson = await new File(assetPath).readAsString();
    final apiConfig = ApiConfiguration.fromJson(json.decode(apiConfigJson));
    final api = new RatesApi(apiConfig);
    api.connectivity = MockConnectivity(ConnectivityResult.wifi);

    final result = await api.getCurrentRatesJson();
    expect(result.successful, true);
  });
}

class MockClient implements Client {

  final Function _response;

  MockClient(Function response) : _response = response;

  @override
  void close() { throw new UnimplementedError(); }

  Future<Response> _generateResponse() {
    return Future.value(_response());
  }

  @override
  Future<Response> delete(url, {Map<String, String> headers}) {
    return _generateResponse();
  }

  @override
  Future<Response> get(url, {Map<String, String> headers}) {
    return _generateResponse();
  }

  @override
  Future<Response> head(url, {Map<String, String> headers}) {
    return _generateResponse();
  }
  @override
  Future<Response> patch(url, {Map<String, String> headers, body, Encoding encoding})  {
    return _generateResponse();
  }

  @override
  Future<Response> post(url, {Map<String, String> headers, body, Encoding encoding})  {
    return _generateResponse();
  }

  @override
  Future<Response> put(url, {Map<String, String> headers, body, Encoding encoding})  {
    return _generateResponse();
  }

  @override
  Future<String> read(url, {Map<String, String> headers}) {
    throw new UnimplementedError();
  }

  @override
  Future<Uint8List> readBytes(url, {Map<String, String> headers})  { throw new UnimplementedError(); }

  @override
  Future<StreamedResponse> send(BaseRequest request)  { throw new UnimplementedError(); }
}

class MockConnectivity implements Connectivity {
  final ConnectivityResult connectivityResult;

  MockConnectivity(this.connectivityResult);

  @override
  Future<ConnectivityResult> checkConnectivity() {
    return Future.value(connectivityResult);
  }

  @override
  Future<String> getWifiName() {
    return Future.value(null);
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged => null;

  @override
  Future<LocationAuthorizationStatus> getLocationServiceAuthorization() {
    throw UnimplementedError();
  }

  @override
  Future<String> getWifiBSSID() {
    throw UnimplementedError();
  }

  @override
  Future<String> getWifiIP() {
    throw UnimplementedError();
  }

  @override
  Future<LocationAuthorizationStatus> requestLocationServiceAuthorization({bool requestAlwaysLocationUsage = false}) {
    // TODO: implement requestLocationServiceAuthorization
    throw UnimplementedError();
  }
}

class MockConfig implements ApiConfiguration {
  @override
  String get apiKey => "apiKey";

  @override
  String get apiUrl => "apiUrl";
}