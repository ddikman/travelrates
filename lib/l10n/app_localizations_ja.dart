// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'Travel Converter';

  @override
  String get currency_comparisons => '通貨比較';

  @override
  String get review_toastMessage =>
      'TravelRatesはいかがでしたか？\n皆様のレビューを参考に、さらにアプリを良いものにしていきます。';

  @override
  String get review_acceptReviewButtonText => 'はい！';

  @override
  String alreadySelectedWarning(String currencyName) {
    return '$currencyNameは既に選択されています！';
  }

  @override
  String get about_title => 'TravelRatesについて';

  @override
  String get about_description =>
      '2019年、東南アジアをバックパッカーとして旅行中、バリ島で風邪を引いている時にTravelRatesを作りリリースしました。\n\n旅人には欠かせないレートアプリ。速さ、使いやすさ、そしてオフラインで使用できるという点が旅人の強い味方。\n\nアプリを使っていただけたら、是非レビューをお願いします。皆様のご意見は、今後も無料でアプリを継続していく励みになります。';

  @override
  String get about_addReview => 'レビューを書く';

  @override
  String get about_callout =>
      '私はフリーランスのフルスタック開発者として働いています。\n\n連絡を取りたい方、このアプリがどのように作られているか知りたい方、またはお仕事の依頼をご検討の方は、[greycastle.se](https://greycastle.se)をご覧ください。';

  @override
  String get theme_title => 'ダークモード';

  @override
  String get theme_dark => 'ダーク';

  @override
  String get theme_light => 'ライト';

  @override
  String get theme_system => 'システム';

  @override
  String get addCurrency_title => '通貨を追加';

  @override
  String get addCurrency_description => '通貨名、使用国、または通貨コードで検索して追加';

  @override
  String get addCurrency_searchPlaceholder => '検索';

  @override
  String get addCurrency_selectedCurrenciesTitle => '選択された通貨';

  @override
  String get addCurrency_selectedCurrenciesSubtitle => '長押しで並び替え';

  @override
  String addCurrency_usedInCountries(String countries) {
    return '選択された国: $countries';
  }
}
