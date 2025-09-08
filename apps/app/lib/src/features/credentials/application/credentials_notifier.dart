import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/credential.dart';

final credentialsNotifierProvider =
    StateNotifierProvider<CredentialsNotifier, List<Credential>>(
      (ref) => CredentialsNotifier(
        initialCredentials: <Credential>[
          Credential(
            id: '1',
            title: 'GitHub',
            username: 'octocat',
            updatedAt: DateTime(2025, 1, 1),
          ),
          Credential(
            id: '2',
            title: 'Gmail',
            username: 'you@example.com',
            updatedAt: DateTime(2025, 2, 10),
          ),
        ],
      ),
    );

class CredentialsNotifier extends StateNotifier<List<Credential>> {
  CredentialsNotifier({List<Credential>? initialCredentials})
    : super(initialCredentials ?? <Credential>[]);

  void addCredential(Credential credential) {
    state = <Credential>[credential, ...state];
  }

  void updateCredential(Credential credential) {
    state = state
        .map((Credential c) => c.id == credential.id ? credential : c)
        .toList(growable: false);
  }

  void removeCredentialById(String id) {
    state = state.where((Credential c) => c.id != id).toList(growable: false);
  }
}
