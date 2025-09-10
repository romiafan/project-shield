// Stub for non-web platforms
import 'dart:typed_data';

Future<String?> pickJsonFile() async {
  throw UnsupportedError('File picker only available on web.');
}

Future<void> exportJsonFile(String json) async {
  throw UnsupportedError('File export only available on web.');
}
