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
  // TOTP fields
  final String? totpSecret;
  final int? totpDigits;
  final int? totpPeriod;
  // Passkey fields
  final String? passkeyCredentialId;
  final String? passkeyPublicKey;
  // Card fields
  final String? cardNumber;
  final String? cardExpiry;
  final String? cardHolder;
  final String? cardCvc;
  // Secure note fields
  final String? noteContent;

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
    this.totpSecret,
    this.totpDigits,
    this.totpPeriod,
    this.passkeyCredentialId,
    this.passkeyPublicKey,
    this.cardNumber,
    this.cardExpiry,
    this.cardHolder,
    this.cardCvc,
    this.noteContent,
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
    String? totpSecret,
    int? totpDigits,
    int? totpPeriod,
    String? passkeyCredentialId,
    String? passkeyPublicKey,
    String? cardNumber,
    String? cardExpiry,
    String? cardHolder,
    String? cardCvc,
    String? noteContent,
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
      totpSecret: totpSecret ?? this.totpSecret,
      totpDigits: totpDigits ?? this.totpDigits,
      totpPeriod: totpPeriod ?? this.totpPeriod,
      passkeyCredentialId: passkeyCredentialId ?? this.passkeyCredentialId,
      passkeyPublicKey: passkeyPublicKey ?? this.passkeyPublicKey,
      cardNumber: cardNumber ?? this.cardNumber,
      cardExpiry: cardExpiry ?? this.cardExpiry,
      cardHolder: cardHolder ?? this.cardHolder,
      cardCvc: cardCvc ?? this.cardCvc,
      noteContent: noteContent ?? this.noteContent,
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
    'totpSecret': totpSecret,
    'totpDigits': totpDigits,
    'totpPeriod': totpPeriod,
    'passkeyCredentialId': passkeyCredentialId,
    'passkeyPublicKey': passkeyPublicKey,
    'cardNumber': cardNumber,
    'cardExpiry': cardExpiry,
    'cardHolder': cardHolder,
    'cardCvc': cardCvc,
    'noteContent': noteContent,
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
    totpSecret: json['totpSecret'] as String?,
    totpDigits: json['totpDigits'] as int?,
    totpPeriod: json['totpPeriod'] as int?,
    passkeyCredentialId: json['passkeyCredentialId'] as String?,
    passkeyPublicKey: json['passkeyPublicKey'] as String?,
    cardNumber: json['cardNumber'] as String?,
    cardExpiry: json['cardExpiry'] as String?,
    cardHolder: json['cardHolder'] as String?,
    cardCvc: json['cardCvc'] as String?,
    noteContent: json['noteContent'] as String?,
  );
}
