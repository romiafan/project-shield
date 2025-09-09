import 'package:meta/meta.dart';

@immutable
class Credential {
  final String id;
  final String title;
  final String username;
  final String password;
  final String? url;
  final String? notes;
  final DateTime updatedAt;
  final bool isDeleted;
  final String type;
  final int version;

  const Credential({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    this.url,
    this.notes,
    required this.updatedAt,
    this.isDeleted = false,
    this.type = 'basic',
    this.version = 1,
  });

  Credential copyWith({
    String? id,
    String? title,
    String? username,
    String? password,
    String? url,
    String? notes,
    DateTime? updatedAt,
    bool? isDeleted,
    String? type,
    int? version,
  }) {
    return Credential(
      id: id ?? this.id,
      title: title ?? this.title,
      username: username ?? this.username,
      password: password ?? this.password,
      url: url ?? this.url,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      type: type ?? this.type,
      version: version ?? this.version,
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'title': title,
    'username': username,
    'password': password,
    'url': url,
    'notes': notes,
    'updatedAt': updatedAt.toIso8601String(),
    'isDeleted': isDeleted,
    'type': type,
    'version': version,
  };

  factory Credential.fromJson(Map<String, Object?> json) => Credential(
    id: json['id'] as String,
    title: json['title'] as String,
    username: json['username'] as String,
    password: json['password'] as String,
    url: json['url'] as String?,
    notes: json['notes'] as String?,
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    isDeleted: json['isDeleted'] as bool? ?? false,
    type: json['type'] as String? ?? 'basic',
    version: json['version'] as int? ?? 1,
  );
}
