// ignore_for_file: avoid_print
//
// Generates release_notes.json from the latest changelog.md entry and translates
// it with the Claude CLI.
//
// Codemagic auto-publishes release_notes.json to Google Play and App Store
// Connect when it is present in the repo root. changelog.md (English) is the
// single source of truth: this script takes the latest entry, fills every
// supported store locale with the English text, then post-processes the file
// with `claude -p` to translate each entry into its language. Run it locally,
// review the result, and commit changelog.md together with release_notes.json.
//
// Run with: fvm dart run tools/generate_release_notes.dart
import 'dart:convert';
import 'dart:io';

/// A supported language and the store locale codes that share its text.
/// App Store uses `sv`/`ja`; Google Play uses `sv-SE`/`ja-JP`; `en-US` and
/// `fr-FR` are accepted by both stores. Codemagic publishes only the codes each
/// store recognises and silently omits the rest, so emitting every variant in
/// one file is safe.
///
/// Keep this list in sync with AppLocalizations.supportedLocales as locales are
/// added (mapping each app locale to its App Store + Google Play codes).
class Language {
  const Language(this.name, this.storeCodes);

  final String name;
  final List<String> storeCodes;
}

const languages = [
  Language('English', ['en-US']),
  Language('Swedish', ['sv', 'sv-SE']),
  Language('Japanese', ['ja', 'ja-JP']),
  Language('French', ['fr-FR']),
];

const changelogFile = 'changelog.md';
const outputFile = 'release_notes.json';
const encoder = JsonEncoder.withIndent('  ');

Never fail(String message) {
  stderr.writeln('ERROR: $message');
  exit(1);
}

/// Returns the body of the first (latest) `## ...` section in changelog.md.
String latestEntry() {
  final file = File(changelogFile);
  if (!file.existsSync()) {
    fail('$changelogFile not found');
  }

  final body = <String>[];
  var inSection = false;
  for (final line in file.readAsLinesSync()) {
    if (line.startsWith('## ')) {
      if (inSection) break; // reached the next entry
      inSection = true;
      continue;
    }
    if (inSection) body.add(line);
  }

  final text = body.join('\n').trim();
  if (text.isEmpty) {
    fail('no release notes found in $changelogFile (expected a "## ..." section)');
  }
  return text;
}

/// Apple rejects "<" and ">" in release notes; they cause API errors.
void ensureNoAngleBrackets(String label, String text) {
  if (text.contains('<') || text.contains('>')) {
    fail('$label contains "<" or ">", which Apple rejects. Remove them.');
  }
}

/// Builds one entry per store locale code, all using the given text.
List<Map<String, String>> buildEntries(String text) {
  return [
    for (final language in languages)
      for (final code in language.storeCodes) {'language': code, 'text': text},
  ];
}

void writeJson(List<Map<String, String>> entries) {
  File(outputFile).writeAsStringSync('${encoder.convert(entries)}\n');
}

/// Parses Claude's reply into a list of {language, text} maps, tolerating a
/// surrounding ```json code fence.
List<Map<String, String>> parseEntries(String raw) {
  var text = raw.trim();
  if (text.startsWith('```')) {
    text = text.replaceFirst(RegExp(r'^```[a-zA-Z]*\s*'), '');
    final fenceEnd = text.lastIndexOf('```');
    if (fenceEnd != -1) text = text.substring(0, fenceEnd);
    text = text.trim();
  }

  dynamic decoded;
  try {
    decoded = jsonDecode(text);
  } on FormatException catch (e) {
    fail('claude did not return valid JSON: ${e.message}\n--- raw output ---\n$raw');
  }
  if (decoded is! List) {
    fail('claude did not return a JSON array.');
  }

  final entries = <Map<String, String>>[];
  for (final item in decoded) {
    if (item is! Map || item['language'] == null || item['text'] == null) {
      fail('claude returned an unexpected array element: $item');
    }
    entries.add({
      'language': item['language'].toString(),
      'text': item['text'].toString(),
    });
  }
  return entries;
}

/// Translates [english] for every store locale by handing the all-English JSON
/// to the Claude CLI, then validates and returns the result in canonical order.
List<Map<String, String>> translate(String english) {
  final guidance = languages
      .map((l) => l.name == 'English'
          ? '- ${l.storeCodes.join(', ')}: keep the English text exactly as-is'
          : '- ${l.storeCodes.join(', ')}: ${l.name}')
      .join('\n');

  final prompt = '''
You are translating release notes for a multi-currency converter mobile app.

Below is a JSON array. Each object has a "language" (a store locale code) and a "text" (currently English). Translate each "text" into the language indicated by its locale code:
$guidance

Rules:
- Keep the JSON structure and every "language" value unchanged; only translate "text".
- Entries that share a base language (sv and sv-SE, ja and ja-JP) must have identical text.
- Preserve the Markdown "- " bullet structure with one bullet per line.
- Never use the characters < or >.
- Output ONLY the resulting JSON array — no preamble, no explanation, no code fences.

${encoder.convert(buildEntries(english))}''';

  print('Translating with claude -p ...');
  final ProcessResult result;
  try {
    result = Process.runSync(
      'claude',
      ['-p', prompt],
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );
  } on ProcessException catch (e) {
    fail(
      'could not run the "claude" CLI (${e.message}). Install Claude Code and '
      'sign in, then re-run. $outputFile currently holds English for all locales.',
    );
  }
  if (result.exitCode != 0) {
    fail('claude exited with ${result.exitCode}:\n${result.stderr}');
  }

  final byCode = {
    for (final entry in parseEntries(result.stdout as String))
      entry['language']!: entry['text']!,
  };

  // Rebuild in canonical order; English stays authoritative from changelog.md.
  final out = <Map<String, String>>[];
  for (final entry in buildEntries(english)) {
    final code = entry['language']!;
    if (code == 'en-US') {
      out.add({'language': code, 'text': english});
      continue;
    }
    final text = byCode[code];
    if (text == null || text.trim().isEmpty) {
      fail('claude did not return a translation for $code.');
    }
    ensureNoAngleBrackets('translation for $code', text);
    out.add({'language': code, 'text': text.trim()});
  }
  return out;
}

void main() {
  print('Generating $outputFile from the latest $changelogFile entry');

  final english = latestEntry();
  ensureNoAngleBrackets('$changelogFile (latest entry)', english);

  // 1. Fill every supported store locale with the English text.
  writeJson(buildEntries(english));

  // 2. Post-process the file with Claude to translate each entry.
  final translated = translate(english);
  writeJson(translated);

  print('Wrote ${translated.length} entries '
      '(${translated.map((e) => e['language']).join(', ')}) to $outputFile');
}
