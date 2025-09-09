import 'dart:convert';
import '../models/credential.dart';

class CredentialsImportExport {
  /// Export credentials to a JSON string
  static String exportToJson(List<Credential> credentials) {
    final List<Map<String, Object?>> jsonList = credentials
        .map((c) => c.toJson())
        .toList();
    return jsonEncode(jsonList);
  }

  /// Import credentials from a JSON string
  static List<Credential> importFromJson(String jsonString) {
    final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded
        .cast<Map<String, Object?>>()
        .map((m) => Credential.fromJson(m))
        .toList();
  }
}
