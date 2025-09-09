import '../models/credential.dart';

enum CredentialsSortMode { nameAsc, nameDesc, updatedDesc }

class FilterAndSortCredentials {
  const FilterAndSortCredentials();

  List<Credential> call({
    required List<Credential> items,
    required String query,
    required CredentialsSortMode sortMode,
  }) {
    List<Credential> result = items;
    final String q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result
          .where(
            (Credential c) =>
                c.title.toLowerCase().contains(q) ||
                c.username.toLowerCase().contains(q) ||
                c.password.toLowerCase().contains(q),
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
  }
}
