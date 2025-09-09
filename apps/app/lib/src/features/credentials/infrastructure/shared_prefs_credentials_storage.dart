import 'dart:convert';
import 'package:core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsCredentialsStorage implements CredentialsStorage {
  SharedPrefsCredentialsStorage(this._prefs);

  static const String _key = 'credentials_v1';
  final SharedPreferences _prefs;

  @override
  Future<List<Credential>> loadAll() async {
    final String? jsonString = _prefs.getString(_key);
    if (jsonString == null || jsonString.isEmpty) return <Credential>[];
    final List<dynamic> decoded = json.decode(jsonString) as List<dynamic>;
    return decoded
        .cast<Map<String, Object?>>()
        .map((Map<String, Object?> m) => Credential.fromJson(m))
        .toList(growable: false);
  }

  @override
  Future<void> saveAll(List<Credential> items) async {
    final String jsonString = json.encode(
      items.map((Credential c) => c.toJson()).toList(growable: false),
    );
    await _prefs.setString(_key, jsonString);
  }
}
