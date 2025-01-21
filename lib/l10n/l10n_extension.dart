import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:travelconverter/l10n/localized_data.dart';
import 'package:travelconverter/l10n/localized_data_provider.dart';

extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  LocalizedData get l10nData => LocalizedDataProvider.of(this);
}
