// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Travel Converter';

  @override
  String get currency_comparisons => 'Comparaisons de devises';

  @override
  String get review_toastMessage =>
      'TravelRates fonctionne-t-il bien pour vous ?\nSi vous pouvez laisser un avis, cela aide vraiment.';

  @override
  String get review_acceptReviewButtonText => 'Bien sûr !';

  @override
  String alreadySelectedWarning(String currencyName) {
    return '$currencyName est déjà sélectionné !';
  }

  @override
  String get about_title => 'À propos de TravelRates';

  @override
  String get about_description =>
      'J\'ai écrit et publié TravelRates pour la première fois en 2019 à Bali, alors que j\'étais enrhumé pendant mon voyage en sac à dos en Asie du Sud-Est.\n\nL\'application a été conçue pour les routards, qui doivent comparer plusieurs devises et pour qui la rapidité, la simplicité et l\'utilisation hors ligne comptent plus qu\'une précision parfaite.\n\nLes taux sont mis à jour depuis une source en ligne dès que vous êtes connecté, et les taux en ligne sont actualisés une fois par jour.\n\nDites-moi si vous aimez l\'application, chaque avis me motive à continuer de la maintenir (et à la garder gratuite) !';

  @override
  String get about_addReview => 'Ajouter un avis';

  @override
  String get about_callout =>
      'Je travaille comme développeur full stack indépendant.\n\nSi vous souhaitez me contacter, découvrir comment cette application est conçue ou même m\'engager, rendez-vous sur [greycastle.se](https://greycastle.se).';

  @override
  String get theme_title => 'Mode sombre';

  @override
  String get theme_dark => 'Sombre';

  @override
  String get theme_light => 'Clair';

  @override
  String get theme_system => 'Système';

  @override
  String get addCurrency_title => 'Ajouter une devise';

  @override
  String get addCurrency_description =>
      'Recherchez des devises à ajouter par nom, pays d\'utilisation ou code de devise';

  @override
  String get addCurrency_searchPlaceholder => 'Rechercher';

  @override
  String get addCurrency_selectedCurrenciesTitle => 'Devises sélectionnées';

  @override
  String get addCurrency_selectedCurrenciesSubtitle =>
      'Appuyez longuement et faites glisser pour réorganiser';

  @override
  String addCurrency_usedInCountries(String countries) {
    return 'Utilisé dans des pays comme : $countries';
  }

  @override
  String get addCurrency_digitalCurrency =>
      'Est une devise numérique utilisée dans le monde entier';

  @override
  String get time_justNow => 'à l\'instant';

  @override
  String time_minutesAgo(int minutes) {
    return 'il y a $minutes min';
  }

  @override
  String time_hoursAgo(int hours) {
    return 'il y a $hours h';
  }

  @override
  String time_daysAgo(int days) {
    return 'il y a $days j';
  }
}
