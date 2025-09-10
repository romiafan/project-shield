// Only included in web builds
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:convert';

Future<String?> pickJsonFile() async {
  final input = html.FileUploadInputElement();
  input.accept = '.json';
  input.click();
  await input.onChange.first;
  final file = input.files?.first;
  if (file != null) {
    final reader = html.FileReader();
    reader.readAsText(file);
    await reader.onLoad.first;
    return reader.result as String;
  }
  return null;
}

Future<void> exportJsonFile(String json) async {
  final bytes = utf8.encode(json);
  final blob = html.Blob([bytes], 'application/json');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', 'credentials_export.json')
    ..click();
  html.Url.revokeObjectUrl(url);
}
