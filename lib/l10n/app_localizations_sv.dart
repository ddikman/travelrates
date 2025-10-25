// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appName => 'Travel Converter';

  @override
  String get currency_comparisons => 'Valutor';

  @override
  String get review_toastMessage =>
      'Fungerar TravelRates bra för dig?\nOm du kan lämna en recension hjälper det verkligen.';

  @override
  String get review_acceptReviewButtonText => 'Ja!';

  @override
  String alreadySelectedWarning(String currencyName) {
    return '$currencyName är redan vald!';
  }

  @override
  String get about_title => 'Om TravelRates';

  @override
  String get about_description =>
      'Jag skrev och släppte TravelRates 2019 under en vecka när jag var förkyld i Bali medan jag backpackade i sydostasien.\n\nJag byggde TravelRates med backpackers i åtanke, folk som behöver jämföra flera valutor och där snabbhet, enkelhet och offline-användning är viktigare än att vara exakt rätt.\n\nLämna gärna en recension om du gillar appen, all feedback motiverar mig att fortsätta driva den (och hålla den gratis)!';

  @override
  String get about_addReview => 'Lägg till recension';

  @override
  String get about_callout =>
      'Jag jobbar som frilansande fullstack-utvecklare.\n\nOm du vill komma i kontakt, kanske lära dig hur denna app är byggd eller anlita mig, besök [greycastle.se](https://greycastle.se).';

  @override
  String get theme_title => 'Mörkt läge';

  @override
  String get theme_dark => 'Mörkt';

  @override
  String get theme_light => 'Ljust';

  @override
  String get theme_system => 'System';

  @override
  String get addCurrency_title => 'Lägg till valuta';

  @override
  String get addCurrency_description =>
      'Sök efter valuta med namn, land eller valutakod';

  @override
  String get addCurrency_searchPlaceholder => 'Sök';

  @override
  String get addCurrency_selectedCurrenciesTitle => 'Valda valutor';

  @override
  String get addCurrency_selectedCurrenciesSubtitle =>
      'Håll ner och dra för att ändra ordning';

  @override
  String addCurrency_usedInCountries(String countries) {
    return 'Används i länder som: $countries';
  }
}
