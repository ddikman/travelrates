// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final apiConfig = jsonDecode(
    File('assets/data/apiConfiguration.json').readAsStringSync(),
  ) as Map<String, dynamic>;

  final url = '${apiConfig['apiUrl']}?token=${apiConfig['apiToken']}';

  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();

    if (response.statusCode != 200) {
      throw Exception('Got response ${response.statusCode} for $url');
    }

    final body = await response.transform(utf8.decoder).join();
    const filename = 'assets/data/rates.json';
    File(filename).writeAsStringSync(body);
    print('updated rates written to $filename');
  } finally {
    client.close();
  }
}
