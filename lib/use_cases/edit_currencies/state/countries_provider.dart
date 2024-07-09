import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelconverter/app_state.dart';
import 'package:travelconverter/model/country.dart';

final countriesProvider = Provider<List<Country>>((ref) {
  final appState = ref.watch(appStateProvider);
  return appState.countries;
});
