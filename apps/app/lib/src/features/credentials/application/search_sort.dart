import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/credential.dart';
import 'credentials_notifier.dart';

enum CredentialsSortMode { nameAsc, nameDesc, updatedDesc }

final credentialsSearchQueryProvider = StateProvider<String>((ref) => '');
final credentialsSortModeProvider = StateProvider<CredentialsSortMode>(
  (ref) => CredentialsSortMode.updatedDesc,
);

final filteredSortedCredentialsProvider = Provider<List<Credential>>((ref) {
  final List<Credential> items = ref.watch(credentialsNotifierProvider);
  final String query = ref
      .watch(credentialsSearchQueryProvider)
      .trim()
      .toLowerCase();
  final CredentialsSortMode sortMode = ref.watch(credentialsSortModeProvider);

  List<Credential> result = items;
  if (query.isNotEmpty) {
    result = result
        .where(
          (Credential c) =>
              c.title.toLowerCase().contains(query) ||
              c.username.toLowerCase().contains(query),
        )
        .toList(growable: false);
  }

  result = List<Credential>.from(result);
  switch (sortMode) {
    case CredentialsSortMode.nameAsc:
      result.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
      break;
    case CredentialsSortMode.nameDesc:
      result.sort(
        (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
      );
      break;
    case CredentialsSortMode.updatedDesc:
      result.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      break;
  }

  return result;
});
