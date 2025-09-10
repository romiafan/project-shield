// Only included in web builds
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

Future<Map<String, String>?> registerWebAuthnPasskey() async {
  final crypto = html.window.crypto;
  final creds = html.window.navigator.credentials;
  if (crypto == null || creds == null) {
    throw Exception('WebAuthn not supported in this browser.');
  }
  final challenge = crypto.getRandomValues(Uint8List(32));
  final options = {
    'publicKey': {
      'challenge': challenge.buffer,
      'rp': {'name': 'Project Shield'},
      'user': {'id': challenge.buffer, 'name': 'user', 'displayName': 'User'},
      'pubKeyCredParams': [
        {'type': 'public-key', 'alg': -7},
      ],
      'timeout': 60000,
      'attestation': 'direct',
    },
  };
  final cred = await creds.create(options);
  if (cred != null && cred.runtimeType.toString() == 'PublicKeyCredential') {
    final credId = cred.rawId;
    final pubKey = cred.response;
    return {'credentialId': credId.toString(), 'publicKey': pubKey.toString()};
  }
  throw Exception('WebAuthn registration failed.');
}
