// Stub for non-web platforms
Future<Map<String, String>?> registerWebAuthnPasskey() async {
  throw UnsupportedError('WebAuthn is only available on web.');
}
