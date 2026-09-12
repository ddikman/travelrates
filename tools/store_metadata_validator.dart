import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

const googleLocales = ['en-US', 'sv-SE', 'ja-JP', 'fr-FR'];
const appleLocales = ['en-US', 'sv', 'ja', 'fr-FR'];
const creativeLocaleForApple = {
  'en-US': 'en-US',
  'sv': 'sv-SE',
  'ja': 'ja-JP',
  'fr-FR': 'fr-FR',
};
const appleCategoryTerms = {
  'en-US': 'travel utilities',
  'sv': 'resor verktyg',
  'ja': '旅行 ユーティリティ',
  'fr-FR': 'voyages utilitaires',
};

List<String> validateStoreMetadata(Directory root) {
  final errors = <String>[];
  final reviewedText = StringBuffer();

  String read(String relativePath) {
    final file = File('${root.path}/$relativePath');
    if (!file.existsSync()) {
      errors.add('Missing $relativePath');
      return '';
    }
    final value = file.readAsStringSync().trim();
    reviewedText.writeln(value);
    return value;
  }

  void checkCharacters(String label, String value, int maximum) {
    final length = value.runes.length;
    if (length > maximum) {
      errors.add('$label is $length characters; maximum is $maximum');
    }
  }

  for (final locale in googleLocales) {
    final base = 'android/fastlane/metadata/android/$locale';
    checkCharacters('$locale Google title', read('$base/title.txt'), 30);
    checkCharacters(
      '$locale Google short description',
      read('$base/short_description.txt'),
      80,
    );
    checkCharacters(
      '$locale Google full description',
      read('$base/full_description.txt'),
      4000,
    );
  }

  for (final locale in appleLocales) {
    final base = 'ios/fastlane/metadata/$locale';
    final name = read('$base/name.txt');
    final subtitle = read('$base/subtitle.txt');
    final keywords = read('$base/keywords.txt');
    checkCharacters('$locale Apple name', name, 30);
    checkCharacters('$locale Apple subtitle', subtitle, 30);
    checkCharacters(
      '$locale Apple promotional text',
      read('$base/promotional_text.txt'),
      170,
    );
    checkCharacters(
      '$locale Apple description',
      read('$base/description.txt'),
      4000,
    );

    final keywordBytes = utf8.encode(keywords).length;
    if (keywordBytes > 100) {
      errors.add(
        '$locale Apple keywords are $keywordBytes bytes; maximum is 100',
      );
    }
    final keywordList = keywords
        .split(',')
        .map((keyword) => keyword.trim().toLowerCase())
        .where((keyword) => keyword.isNotEmpty)
        .toList();
    if (keywordList.length != keywordList.toSet().length) {
      errors.add('$locale Apple keywords contain duplicates');
    }
    if (keywordList.contains('app')) {
      errors.add(
        '$locale Apple keywords must not contain the generic word app',
      );
    }
    final visibleWords = '$name $subtitle ${appleCategoryTerms[locale]}'
        .toLowerCase()
        .split(RegExp(r'[^\p{L}\p{N}]+', unicode: true))
        .where((word) => word.isNotEmpty)
        .toSet();
    final duplicates = keywordList.where(visibleWords.contains).toList();
    if (duplicates.isNotEmpty) {
      errors.add(
        '$locale Apple keywords duplicate visible metadata: ${duplicates.join(', ')}',
      );
    }
  }

  final creativeFile = File('${root.path}/store/creative_copy.json');
  Map<String, dynamic>? creative;
  if (!creativeFile.existsSync()) {
    errors.add('Missing store/creative_copy.json');
  } else {
    try {
      creative =
          jsonDecode(creativeFile.readAsStringSync()) as Map<String, dynamic>;
      reviewedText.writeln(creativeFile.readAsStringSync());
    } catch (error) {
      errors.add('Invalid store/creative_copy.json: $error');
    }
  }

  if (creative != null) {
    final englishCreative =
        creative['locales']?['en-US'] as Map<String, dynamic>?;
    if (englishCreative?['featureHeadline'] !=
        'All your travel currencies.\nIn one single view.') {
      errors.add('English feature graphic headline is not the approved copy');
    }
    final screens = creative['screens'];
    if (screens is! List || screens.length != 5) {
      errors.add('Creative manifest must define exactly five screens');
    }
    final locales = creative['locales'];
    if (locales is! Map<String, dynamic>) {
      errors.add('Creative manifest locales are missing');
    } else {
      for (final locale in googleLocales) {
        final entry = locales[locale];
        if (entry is! Map<String, dynamic>) {
          errors.add('Creative manifest is missing $locale');
          continue;
        }
        final screenshots = entry['screenshots'];
        if (screenshots is! List || screenshots.length != 5) {
          errors.add('$locale must have exactly five screenshot captions');
        }
        for (final key in ['featureHeadline', 'featureTagline']) {
          if (entry[key] is! String || (entry[key] as String).trim().isEmpty) {
            errors.add('$locale creative $key is missing');
          }
        }
      }
    }
  }

  final englishDescription = read(
    'android/fastlane/metadata/android/en-US/full_description.txt',
  ).toLowerCase();
  for (final term in [
    'currency converter app',
    'backpackers',
    'offline',
    'multiple currencies',
  ]) {
    if (!englishDescription.contains(term)) {
      errors.add('English description must contain "$term"');
    }
  }

  final text = reviewedText.toString();
  final banned = <String, RegExp>{
    'competitor reference': RegExp(r'\bxe\b', caseSensitive: false),
    'stale currency count': RegExp(r'\b168\b'),
    'misspelling "convertor"': RegExp(r'\bconvertor\b', caseSensitive: false),
    'ranking claim': RegExp(
      r'\b(?:number\s*one|top[- ]rated|best[- ]ranked|rank(?:ed|ing)?\s*#?\d+)\b',
      caseSensitive: false,
    ),
    'stale screenshot copy': RegExp(
      r'\brateconversion\b',
      caseSensitive: false,
    ),
  };
  for (final entry in banned.entries) {
    if (entry.value.hasMatch(text)) {
      errors.add('Reviewed store copy contains ${entry.key}');
    }
  }

  for (final locale in googleLocales) {
    final base = 'assets/store/google_play/$locale';
    for (var index = 1; index <= 5; index++) {
      _checkPng(
        root,
        '$base/$index.png',
        expectedWidth: 1440,
        expectedHeight: 2560,
        errors: errors,
      );
    }
    _checkPng(
      root,
      '$base/featureGraphic.png',
      expectedWidth: 1024,
      expectedHeight: 500,
      errors: errors,
    );
  }

  for (final locale in appleLocales) {
    final creativeLocale = creativeLocaleForApple[locale]!;
    final base = 'assets/store/app_store/$creativeLocale';
    for (var index = 1; index <= 5; index++) {
      _checkPng(
        root,
        '$base/$index.png',
        expectedWidth: 1320,
        expectedHeight: 2868,
        errors: errors,
      );
    }
  }

  return errors;
}

void _checkPng(
  Directory root,
  String relativePath, {
  required int expectedWidth,
  required int expectedHeight,
  required List<String> errors,
}) {
  final file = File('${root.path}/$relativePath');
  if (!file.existsSync()) {
    errors.add('Missing $relativePath');
    return;
  }
  final bytes = file.readAsBytesSync();
  const pngSignature = [137, 80, 78, 71, 13, 10, 26, 10];
  if (bytes.length < 24 ||
      List.generate(8, (index) => bytes[index]).asMap().entries.any(
        (entry) => entry.value != pngSignature[entry.key],
      )) {
    errors.add('$relativePath is not a valid PNG');
    return;
  }
  final data = ByteData.sublistView(Uint8List.fromList(bytes));
  final width = data.getUint32(16);
  final height = data.getUint32(20);
  if (width != expectedWidth || height != expectedHeight) {
    errors.add(
      '$relativePath is $width×$height; expected $expectedWidth×$expectedHeight',
    );
  }
}
