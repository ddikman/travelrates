import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:travelconverter/internet_connectivity.dart';

@GenerateNiceMocks([MockSpec<Connectivity>()])
import 'internet_connectivity_test.mocks.dart';

void main() {
  StreamController<ConnectivityResult>? connectivityStream;

  setUp(() {
    connectivityStream = new StreamController<ConnectivityResult>(sync: true);
  });

  tearDown(() {
    connectivityStream?.close();
  });

  InternetConnectivity getWithCurrentConnectivity(
      ConnectivityResult connectivity) {
    final mockConnectivity = new MockConnectivity();
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => connectivity);
    when(mockConnectivity.onConnectivityChanged)
        .thenAnswer((_) => connectivityStream!.stream);

    return new InternetConnectivityImpl(mockConnectivity);
  }

  test("is available after startup if connectivity is mobile", () async {
    var internet = getWithCurrentConnectivity(ConnectivityResult.mobile);
    expect(internet.isAvailable, true);
  });

  test("is available after startup if connectivity is wifi", () async {
    var internet = getWithCurrentConnectivity(ConnectivityResult.wifi);
    expect(internet.isAvailable, true);
  });

  test("is unavailable after startup if connectivity is none", () async {
    var internet = getWithCurrentConnectivity(ConnectivityResult.none);
    expect(internet.isAvailable, false);
  });

  test("becomes available when connectivity changes", () async {
    var internet = getWithCurrentConnectivity(ConnectivityResult.none);
    expect(internet.isAvailable, false);

    connectivityStream?.add(ConnectivityResult.mobile);
    expect(internet.isAvailable, true);
  });
}
