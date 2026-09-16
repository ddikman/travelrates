import 'dart:convert';
import 'dart:io';

const _googleLocales = ['en-US', 'sv-SE', 'ja-JP', 'fr-FR'];
const _appleLocales = ['en-US', 'sv-SE', 'ja-JP', 'fr-FR'];
const _sources = [
  '01-compare',
  '02-offline',
  '03-search',
  '04-calculator',
  '05-appearance',
];

enum _Scope { all, google, apple }

enum _Platform { android, ios }

late final Directory _root;
late final Directory _temporaryDirectory;
late final File _background;
late final Map<String, dynamic> _locales;

const _font = '/System/Library/Fonts/Supplemental/Arial Unicode.ttf';

void main(List<String> arguments) {
  final scope = _parseScope(arguments);
  _root = Directory.current.absolute;

  final manifest = File('${_root.path}/store/creative_copy.json');
  _background = File(
    '${_root.path}/store/assets/source/beach-left-background.png',
  );
  _requireFile(File('${_root.path}/pubspec.yaml'));
  _requireFile(manifest);
  _requireFile(_background);
  _requireFile(File(_font));
  _verifyImageMagick();

  final creativeCopy = jsonDecode(manifest.readAsStringSync());
  if (creativeCopy is! Map<String, dynamic> ||
      creativeCopy['locales'] is! Map<String, dynamic>) {
    throw const FormatException(
      'store/creative_copy.json must contain a locales object.',
    );
  }
  _locales = creativeCopy['locales'] as Map<String, dynamic>;
  _temporaryDirectory = Directory.systemTemp.createTempSync(
    'travelrates-store-',
  );

  try {
    if (scope == _Scope.all || scope == _Scope.google) {
      for (final locale in _googleLocales) {
        for (var index = 1; index <= _sources.length; index++) {
          _makeStoreScreenshot(
            platform: _Platform.android,
            locale: locale,
            index: index,
            width: 1440,
            height: 2560,
          );
        }
        _makeFeatureGraphic(locale);
      }
    }

    if (scope == _Scope.all || scope == _Scope.apple) {
      for (final locale in _appleLocales) {
        for (var index = 1; index <= _sources.length; index++) {
          _makeStoreScreenshot(
            platform: _Platform.ios,
            locale: locale,
            index: index,
            width: 1320,
            height: 2868,
          );
        }
      }
    }
  } finally {
    _temporaryDirectory.deleteSync(recursive: true);
  }

  stdout.writeln('Generated localized store creatives under store/assets.');
}

_Scope _parseScope(List<String> arguments) {
  if (arguments.length > 1) {
    _usageError();
  }
  final argument = arguments.isEmpty ? null : arguments.first;
  return switch (argument) {
    null || 'all' => _Scope.all,
    'google' => _Scope.google,
    'apple' => _Scope.apple,
    _ => _usageError(),
  };
}

Never _usageError() {
  stderr.writeln(
    'Usage: fvm dart run tools/generate_store_creatives.dart '
    '[all|google|apple]',
  );
  exit(2);
}

void _makeText({
  required String text,
  required int width,
  required int height,
  required int pointSize,
  required File output,
}) {
  _runMagick([
    '-background',
    'none',
    '-fill',
    'white',
    '-font',
    _font,
    '-pointsize',
    '$pointSize',
    '-gravity',
    'center',
    '-interline-spacing',
    '8',
    '-size',
    '${width}x$height',
    'caption:$text',
    output.path,
  ]);
}

void _makeDeviceMockup({
  required _Platform platform,
  required File source,
  required int maximumWidth,
  required int maximumHeight,
  required File output,
}) {
  final platformName = platform.name;
  final content = File(
    '${_temporaryDirectory.path}/mockup-content-$platformName.png',
  );
  final mask = File(
    '${_temporaryDirectory.path}/mockup-mask-$platformName.png',
  );

  _runMagick([
    source.path,
    '-resize',
    '${maximumWidth}x$maximumHeight',
    '+repage',
    content.path,
  ]);

  final contentWidth = _identify(content, '%w');
  final contentHeight = _identify(content, '%h');
  final isIos = platform == _Platform.ios;
  final radius = contentWidth * (isIos ? 8 : 6) ~/ 100;
  final bezel = contentWidth * (isIos ? 2 : 3) ~/ 100;
  final sideGutter = isIos ? contentWidth * 2 ~/ 100 : 0;
  final frameWidth = contentWidth + bezel * 2;
  final frameHeight = contentHeight + bezel * 2;
  final canvasWidth = frameWidth + sideGutter * 2;
  final shellX = sideGutter;

  _runMagick([
    '-size',
    '${contentWidth}x$contentHeight',
    'xc:none',
    '-fill',
    'white',
    '-stroke',
    'none',
    '-draw',
    'roundrectangle 0,0,${contentWidth - 1},${contentHeight - 1},'
        '$radius,$radius',
    mask.path,
  ]);
  _runMagick([
    content.path,
    mask.path,
    '-alpha',
    'off',
    '-compose',
    'CopyOpacity',
    '-composite',
    content.path,
  ]);

  if (isIos) {
    final actionY = frameHeight * 16 ~/ 100;
    final volumeUpY = frameHeight * 22 ~/ 100;
    final volumeDownY = frameHeight * 29 ~/ 100;
    final powerY = frameHeight * 23 ~/ 100;

    _runMagick([
      '-size',
      '${canvasWidth}x$frameHeight',
      'xc:none',
      '-fill',
      '#858F96',
      '-stroke',
      '#D9DEE1',
      '-strokewidth',
      '2',
      '-draw',
      'roundrectangle 1,$actionY,${sideGutter + 5},'
          '${actionY + frameHeight * 3 ~/ 100},5,5',
      '-draw',
      'roundrectangle 1,$volumeUpY,${sideGutter + 5},'
          '${volumeUpY + frameHeight * 6 ~/ 100},5,5',
      '-draw',
      'roundrectangle 1,$volumeDownY,${sideGutter + 5},'
          '${volumeDownY + frameHeight * 6 ~/ 100},5,5',
      '-draw',
      'roundrectangle ${canvasWidth - sideGutter - 6},$powerY,'
          '${canvasWidth - 2},${powerY + frameHeight * 9 ~/ 100},5,5',
      '-fill',
      '#080B0E',
      '-stroke',
      '#D5DADD',
      '-strokewidth',
      '7',
      '-draw',
      'roundrectangle ${shellX + 4},4,${shellX + frameWidth - 5},'
          '${frameHeight - 5},${radius + bezel},${radius + bezel}',
      '-fill',
      'none',
      '-stroke',
      '#667078',
      '-strokewidth',
      '3',
      '-draw',
      'roundrectangle ${shellX + bezel - 2},${bezel - 2},'
          '${shellX + frameWidth - bezel + 1},${frameHeight - bezel + 1},'
          '${radius + 2},${radius + 2}',
      content.path,
      '-gravity',
      'northwest',
      '-geometry',
      '+${shellX + bezel}+$bezel',
      '-composite',
      output.path,
    ]);
    return;
  }

  _runMagick([
    '-size',
    '${frameWidth}x$frameHeight',
    'xc:none',
    '-fill',
    '#11171D',
    '-stroke',
    '#C4CCD2',
    '-strokewidth',
    '4',
    '-draw',
    'roundrectangle 2,2,${frameWidth - 3},${frameHeight - 3},'
        '${radius + bezel},${radius + bezel}',
    '-fill',
    'none',
    '-stroke',
    '#49545D',
    '-strokewidth',
    '3',
    '-draw',
    'roundrectangle ${bezel - 2},${bezel - 2},'
        '${frameWidth - bezel + 1},${frameHeight - bezel + 1},'
        '${radius + 2},${radius + 2}',
    content.path,
    '-gravity',
    'northwest',
    '-geometry',
    '+$bezel+$bezel',
    '-composite',
    output.path,
  ]);

  final cameraX = frameWidth ~/ 2;
  final cameraY = bezel + contentWidth * 2 ~/ 100;
  final cameraRadius = contentWidth * 7 ~/ 1000;
  _runMagick([
    output.path,
    '-fill',
    '#090D10',
    '-stroke',
    '#66727B',
    '-strokewidth',
    '2',
    '-draw',
    'circle $cameraX,$cameraY ${cameraX + cameraRadius},$cameraY',
    output.path,
  ]);
}

void _makeStoreScreenshot({
  required _Platform platform,
  required String locale,
  required int index,
  required int width,
  required int height,
}) {
  final source = File(
    '${_root.path}/store/assets/source/${platform.name}/'
    '${_sources[index - 1]}.png',
  );
  _requireFile(source);

  final platformDirectory = platform == _Platform.ios
      ? 'app_store'
      : 'google_play';
  final outputDirectory = Directory(
    '${_root.path}/store/assets/$platformDirectory/$locale',
  )..createSync(recursive: true);
  final output = File('${outputDirectory.path}/$index.png');
  final localeCopy = _localeCopy(locale);
  final captions = localeCopy['screenshots'];
  if (captions is! List || captions.length != _sources.length) {
    throw FormatException('$locale must contain five screenshot captions.');
  }
  final caption = captions[index - 1] as String;

  final topHeight = height * 17 ~/ 100;
  final screenWidth = width * 68 ~/ 100;
  final screenHeight = height * 75 ~/ 100;
  final screenY = height * 22 ~/ 100;
  final headline = File(
    '${_temporaryDirectory.path}/headline-${platform.name}-$locale-$index.png',
  );
  final screen = File(
    '${_temporaryDirectory.path}/screen-${platform.name}-$locale-$index.png',
  );

  _makeText(
    text: caption,
    width: width * 88 ~/ 100,
    height: topHeight,
    pointSize: width * 54 ~/ 1000,
    output: headline,
  );
  _makeDeviceMockup(
    platform: platform,
    source: source,
    maximumWidth: screenWidth,
    maximumHeight: screenHeight,
    output: screen,
  );

  final mockupWidth = _identify(screen, '%w');
  final mockupX = (width - mockupWidth) ~/ 2;

  _runMagick([
    _background.path,
    '-resize',
    '${width}x$height^',
    '-gravity',
    'center',
    '-extent',
    '${width}x$height',
    '-fill',
    '#062F3D92',
    '-colorize',
    '38',
    headline.path,
    '-gravity',
    'north',
    '-geometry',
    '+0+${height * 3 ~/ 100}',
    '-composite',
    '(',
    screen.path,
    '-background',
    '#00151FAA',
    '-shadow',
    '72x26+0+30',
    ')',
    '-gravity',
    'northwest',
    '-geometry',
    '+$mockupX+$screenY',
    '-composite',
    screen.path,
    '-gravity',
    'northwest',
    '-geometry',
    '+$mockupX+$screenY',
    '-composite',
    '-strip',
    output.path,
  ]);
}

void _makeFeatureGraphic(String locale) {
  final outputDirectory = Directory(
    '${_root.path}/store/assets/google_play/$locale',
  )..createSync(recursive: true);
  final localeCopy = _localeCopy(locale);
  final headline = localeCopy['featureHeadline'] as String;
  final tagline = localeCopy['featureTagline'] as String;
  final headlineImage = File(
    '${_temporaryDirectory.path}/feature-headline-$locale.png',
  );
  final taglineImage = File(
    '${_temporaryDirectory.path}/feature-tagline-$locale.png',
  );

  _makeText(
    text: headline,
    width: 900,
    height: 220,
    pointSize: 48,
    output: headlineImage,
  );
  _makeText(
    text: tagline,
    width: 900,
    height: 80,
    pointSize: 27,
    output: taglineImage,
  );
  _runMagick([
    _background.path,
    '-resize',
    '1024x500^',
    '-gravity',
    'center',
    '-extent',
    '1024x500',
    '-fill',
    '#062F3DA0',
    '-colorize',
    '44',
    headlineImage.path,
    '-gravity',
    'north',
    '-geometry',
    '+0+55',
    '-composite',
    taglineImage.path,
    '-gravity',
    'south',
    '-geometry',
    '+0+55',
    '-composite',
    '-strip',
    '${outputDirectory.path}/featureGraphic.png',
  ]);
}

Map<String, dynamic> _localeCopy(String locale) {
  final copy = _locales[locale];
  if (copy is! Map<String, dynamic>) {
    throw FormatException('Missing creative copy for $locale.');
  }
  return copy;
}

int _identify(File image, String format) {
  final result = _runMagick(['identify', '-format', format, image.path]);
  return int.parse((result.stdout as String).trim());
}

ProcessResult _runMagick(List<String> arguments) {
  final result = Process.runSync('magick', arguments);
  if (result.exitCode != 0) {
    stderr.write(result.stdout);
    stderr.write(result.stderr);
    throw ProcessException('magick', arguments, 'ImageMagick failed.');
  }
  return result;
}

void _verifyImageMagick() {
  try {
    final result = Process.runSync('magick', ['-version']);
    if (result.exitCode != 0) {
      throw ProcessException('magick', const ['-version']);
    }
  } on ProcessException {
    throw StateError(
      'ImageMagick 7 is required. Install it with: brew install imagemagick',
    );
  }
}

void _requireFile(File file) {
  if (!file.existsSync()) {
    throw FileSystemException('Required file is missing.', file.path);
  }
}
