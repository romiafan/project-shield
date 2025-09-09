import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/credential.dart';
import 'package:core/core.dart' as core;
import '../infrastructure/shared_prefs_credentials_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final credentialsNotifierProvider =
    StateNotifierProvider<CredentialsNotifier, List<Credential>>(
      (ref) => throw UnimplementedError(
        'Call credentialsNotifierProviderInit instead',
      ),
    );

final credentialsNotifierProviderInit = FutureProvider<CredentialsNotifier>((
  ref,
) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final core.CredentialsStorage storage = SharedPrefsCredentialsStorage(prefs);
  final CredentialsNotifier notifier = CredentialsNotifier(storage: storage);
  await notifier.load();
  ref.onDispose(notifier.dispose);
  return notifier;
});

class CredentialsNotifier extends StateNotifier<List<Credential>> {
  List<Credential> get credentials => state;
  CredentialsNotifier({required core.CredentialsStorage storage})
    : _storage = storage,
      super(<Credential>[]);

  final core.CredentialsStorage _storage;

  Future<void> load() async {
    final List<Credential> items = await _storage.loadAll();
    state = items;
  }

  void addCredential(Credential credential) {
    state = <Credential>[credential, ...state];
    _save();
  }

  void updateCredential(Credential credential) {
    state = state
        .map((Credential c) => c.id == credential.id ? credential : c)
        .toList(growable: false);
    _save();
  }

  void removeCredentialById(String id) {
    state = state
        .map((Credential c) => c.id == id ? c.copyWith(isDeleted: true) : c)
        .toList(growable: false);
    _save();
  }

  void restoreCredentialById(String id) {
    state = state
        .map((Credential c) => c.id == id ? c.copyWith(isDeleted: false) : c)
        .toList(growable: false);
    _save();
  }

  void permanentlyDeleteCredentialById(String id) {
    state = state.where((Credential c) => c.id != id).toList(growable: false);
    _save();
  }

  Future<void> _save() async {
    await _storage.saveAll(state);
  }
}
