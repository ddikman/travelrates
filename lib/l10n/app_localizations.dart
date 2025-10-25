import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('sv')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Travel Converter'**
  String get appName;

  /// No description provided for @currency_comparisons.
  ///
  /// In en, this message translates to:
  /// **'Currency comparisons'**
  String get currency_comparisons;

  /// No description provided for @review_toastMessage.
  ///
  /// In en, this message translates to:
  /// **'Is TravelRates working well for you?\nIf you can leave a review, it really helps.'**
  String get review_toastMessage;

  /// No description provided for @review_acceptReviewButtonText.
  ///
  /// In en, this message translates to:
  /// **'Sure!'**
  String get review_acceptReviewButtonText;

  /// No description provided for @alreadySelectedWarning.
  ///
  /// In en, this message translates to:
  /// **'{currencyName} is already selected!'**
  String alreadySelectedWarning(String currencyName);

  /// No description provided for @about_title.
  ///
  /// In en, this message translates to:
  /// **'About TravelRates'**
  String get about_title;

  /// No description provided for @about_description.
  ///
  /// In en, this message translates to:
  /// **'I first wrote and released TravelRates in 2019 in Bali whilst being sick with a cold when backpacking south east Asia.\n\nIt was built with backpackers in mind, where you have to compare against multiple currencies and speed, ease and offline use are more important than being exactly right.\n\nLet me know if you enjoy the app, every review motivates me to keep it running (and free)!'**
  String get about_description;

  /// No description provided for @about_addReview.
  ///
  /// In en, this message translates to:
  /// **'Add review'**
  String get about_addReview;

  /// No description provided for @about_callout.
  ///
  /// In en, this message translates to:
  /// **'I work as a freelance full stack developer.\n\nIf you want to get in touch, perhaps learn how this app is built or even hire me, visit [greycastle.se](https://greycastle.se).'**
  String get about_callout;

  /// No description provided for @theme_title.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get theme_title;

  /// No description provided for @theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get theme_dark;

  /// No description provided for @theme_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get theme_light;

  /// No description provided for @theme_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get theme_system;

  /// No description provided for @addCurrency_title.
  ///
  /// In en, this message translates to:
  /// **'Add currency'**
  String get addCurrency_title;

  /// No description provided for @addCurrency_description.
  ///
  /// In en, this message translates to:
  /// **'Search for currencies to add by name, country of use or currency code'**
  String get addCurrency_description;

  /// No description provided for @addCurrency_searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get addCurrency_searchPlaceholder;

  /// No description provided for @addCurrency_selectedCurrenciesTitle.
  ///
  /// In en, this message translates to:
  /// **'Selected currencies'**
  String get addCurrency_selectedCurrenciesTitle;

  /// No description provided for @addCurrency_selectedCurrenciesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Long press and drag to reorder'**
  String get addCurrency_selectedCurrenciesSubtitle;

  /// No description provided for @addCurrency_usedInCountries.
  ///
  /// In en, this message translates to:
  /// **'Used in countries like: {countries}'**
  String addCurrency_usedInCountries(String countries);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'sv'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
