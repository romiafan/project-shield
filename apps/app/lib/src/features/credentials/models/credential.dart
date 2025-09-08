import 'package:flutter/foundation.dart';

@immutable
class Credential {
  final String id;
  final String title;
  final String username;
  final DateTime updatedAt;

  const Credential({
    required this.id,
    required this.title,
    required this.username,
    required this.updatedAt,
  });

  String get maskedPassword => '••••••••';
}
