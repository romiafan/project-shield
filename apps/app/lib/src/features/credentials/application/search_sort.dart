import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/credential.dart';
import 'credentials_notifier.dart';
import 'package:core/core.dart' as core;

final credentialsSearchQueryProvider = StateProvider<String>((ref) => '');
final credentialsSortModeProvider = StateProvider<core.CredentialsSortMode>(
  (ref) => core.CredentialsSortMode.updatedDesc,
);

final filteredSortedCredentialsProvider = Provider<List<Credential>>((ref) {
  final AsyncValue<CredentialsNotifier> init = ref.watch(
    credentialsNotifierProviderInit,
  );
  if (init.hasError || init.isLoading || !init.hasValue) {
    return <Credential>[];
  }
  final List<Credential> items = init.value!.credentials;
  final String query = ref.watch(credentialsSearchQueryProvider);
  final core.CredentialsSortMode sortMode = ref.watch(
    credentialsSortModeProvider,
  );

  return const core.FilterAndSortCredentials().call(
    items: items,
    query: query,
    sortMode: sortMode,
  );
});
