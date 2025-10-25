// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Travel Converter';

  @override
  String get currency_comparisons => 'Currency comparisons';

  @override
  String get review_toastMessage =>
      'Is TravelRates working well for you?\nIf you can leave a review, it really helps.';

  @override
  String get review_acceptReviewButtonText => 'Sure!';

  @override
  String alreadySelectedWarning(String currencyName) {
    return '$currencyName is already selected!';
  }

  @override
  String get about_title => 'About TravelRates';

  @override
  String get about_description =>
      'I first wrote and released TravelRates in 2019 in Bali whilst being sick with a cold when backpacking south east Asia.\n\nIt was built with backpackers in mind, where you have to compare against multiple currencies and speed, ease and offline use are more important than being exactly right.\n\nLet me know if you enjoy the app, every review motivates me to keep it running (and free)!';

  @override
  String get about_addReview => 'Add review';

  @override
  String get about_callout =>
      'I work as a freelance full stack developer.\n\nIf you want to get in touch, perhaps learn how this app is built or even hire me, visit [greycastle.se](https://greycastle.se).';

  @override
  String get theme_title => 'Dark mode';

  @override
  String get theme_dark => 'Dark';

  @override
  String get theme_light => 'Light';

  @override
  String get theme_system => 'System';

  @override
  String get addCurrency_title => 'Add currency';

  @override
  String get addCurrency_description =>
      'Search for currencies to add by name, country of use or currency code';

  @override
  String get addCurrency_searchPlaceholder => 'Search';

  @override
  String get addCurrency_selectedCurrenciesTitle => 'Selected currencies';

  @override
  String get addCurrency_selectedCurrenciesSubtitle =>
      'Long press and drag to reorder';

  @override
  String addCurrency_usedInCountries(String countries) {
    return 'Used in countries like: $countries';
  }
}
