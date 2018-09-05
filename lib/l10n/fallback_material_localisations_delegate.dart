import 'dart:async';
import 'package:flutter/material.dart';

// Class to handle the issues around non-translated widgets
// See this issue for full details: https://github.com/flutter/flutter/issues/13482
class FallbackMaterialLocalisationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) => DefaultMaterialLocalizations.load(locale);

  @override
  bool shouldReload(FallbackMaterialLocalisationsDelegate old) => false;
}