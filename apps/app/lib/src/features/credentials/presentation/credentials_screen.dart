import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/credentials_notifier.dart';
import '../models/credential.dart';
import '../application/search_sort.dart';
import 'package:core/core.dart' as core;
import 'package:core/src/services/credentials_import_export.dart';
import 'add_edit_credential_screen.dart';
import '../../../common/feature_config_provider.dart';

// Local provider for password visibility state
final _passwordVisibilityProvider = StateProvider<Map<String, bool>>(
  (ref) => {},
);

// Use the notifier provider for state management

class CredentialsScreen extends ConsumerWidget {
  const CredentialsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featureConfig = ref.watch(featureConfigProvider);
    // Declare trashed credentials after isLoading/hasError
    // Declare trashed after isLoading/hasError assignments
    // Track password visibility per credential
    final passwordVisibility = ref.watch(_passwordVisibilityProvider);
    final AsyncValue<CredentialsNotifier> init = ref.watch(
      credentialsNotifierProviderInit,
    );
    final bool hasError = init.hasError;
    final List<Credential> items = (init.isLoading || hasError)
        ? <Credential>[
            Credential(
              id: 'demo1',
              title: 'Demo Email',
              username: 'demo@email.com',
              password: 'demo_password1',
              updatedAt: DateTime.now(),
            ),
            Credential(
              id: 'demo2',
              title: 'Demo Bank',
              username: 'demo_user',
              password: 'demo_password2',
              updatedAt: DateTime.now(),
            ),
          ]
        : ref.watch(filteredSortedCredentialsProvider);

    final core.CredentialsSortMode sortMode = ref.watch(
      credentialsSortModeProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vault'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: TextField(
              onChanged: (String v) =>
                  ref.read(credentialsSearchQueryProvider.notifier).state = v,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search credentials',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          if (featureConfig['trash_can'] ?? false)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Trash Can',
              onPressed: () {
                final List<Credential> trashed = (init.isLoading || hasError)
                    ? <Credential>[]
                    : ref
                          .watch(credentialsNotifierProvider)
                          .where((c) => c.isDeleted)
                          .toList();
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext ctx) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 12),
                        const Text(
                          'Trash Can',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        if (trashed.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('No deleted credentials.'),
                          )
                        else
                          ...trashed.map(
                            (c) => ListTile(
                              title: Text(c.title),
                              subtitle: Text(c.username),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(Icons.restore),
                                    tooltip: 'Restore',
                                    onPressed: () {
                                      ref
                                          .read(
                                            credentialsNotifierProvider
                                                .notifier,
                                          )
                                          .restoreCredentialById(c.id);
                                      Navigator.of(ctx).pop();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Credential restored!'),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_forever),
                                    tooltip: 'Delete permanently',
                                    onPressed: () {
                                      ref
                                          .read(
                                            credentialsNotifierProvider
                                                .notifier,
                                          )
                                          .permanentlyDeleteCredentialById(
                                            c.id,
                                          );
                                      Navigator.of(ctx).pop();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Credential permanently deleted!',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                      ],
                    );
                  },
                );
              },
            ),
          PopupMenuButton<core.CredentialsSortMode>(
            initialValue: sortMode,
            onSelected: (core.CredentialsSortMode value) {
              ref.read(credentialsSortModeProvider.notifier).state = value;
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<core.CredentialsSortMode>>[
                  const PopupMenuItem<core.CredentialsSortMode>(
                    value: core.CredentialsSortMode.updatedDesc,
                    child: Text('Sort: Recently Updated'),
                  ),
                  const PopupMenuItem<core.CredentialsSortMode>(
                    value: core.CredentialsSortMode.nameAsc,
                    child: Text('Sort: Name A→Z'),
                  ),
                  const PopupMenuItem<core.CredentialsSortMode>(
                    value: core.CredentialsSortMode.nameDesc,
                    child: Text('Sort: Name Z→A'),
                  ),
                ],
          ),
          if (featureConfig['import_export'] ?? false)
            IconButton(
              icon: const Icon(Icons.file_upload),
              tooltip: 'Export credentials',
              onPressed: () async {
                final creds = ref.read(credentialsNotifierProvider);
                final json = CredentialsImportExport.exportToJson(creds);
                await Clipboard.setData(ClipboardData(text: json));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Credentials exported to clipboard!'),
                  ),
                );
              },
            ),
          if (featureConfig['import_export'] ?? false)
            IconButton(
              icon: const Icon(Icons.file_download),
              tooltip: 'Import credentials',
              onPressed: () async {
                final data = await Clipboard.getData('text/plain');
                if (data != null &&
                    data.text != null &&
                    data.text!.isNotEmpty) {
                  try {
                    final imported = CredentialsImportExport.importFromJson(
                      data.text!,
                    );
                    final notifier = ref.read(
                      credentialsNotifierProvider.notifier,
                    );
                    for (final cred in imported) {
                      notifier.addCredential(cred);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Credentials imported from clipboard!'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Import failed: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Clipboard is empty!')),
                  );
                }
              },
            ),
        ],
      ),
      body: init.isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
          ? Column(
              children: <Widget>[
                const SizedBox(height: 32),
                const Text('Error initializing storage'),
                const SizedBox(height: 16),
                const Text('Showing demo credentials.'),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (BuildContext context, int index) {
                      final Credential item = items[index];
                      return ListTile(
                        title: Text(item.title),
                        subtitle: Text(item.username),
                        trailing: const Icon(Icons.chevron_right),
                      );
                    },
                  ),
                ),
              ],
            )
          : items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.shield_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text('No credentials found.'),
                  const SizedBox(height: 8),
                  const Text('Tap + to add your first password.'),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.only(top: 8),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (BuildContext context, int index) {
                final Credential item = items[index];
                final isVisible = passwordVisibility[item.id] ?? false;
                return Dismissible(
                  key: ValueKey<String>(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.error,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    if (init.hasValue) {
                      init.value!.removeCredentialById(item.id);
                    }
                  },
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (item.type == 'totp') ...[
                          Text('TOTP Secret: ${item.totpSecret ?? ''}'),
                          Text('Digits: ${item.totpDigits ?? ''}'),
                          Text('Period: ${item.totpPeriod ?? ''}'),
                        ] else if (item.type == 'passkey') ...[
                          Text('Passkey ID: ${item.passkeyCredentialId ?? ''}'),
                          Text('Public Key: ${item.passkeyPublicKey ?? ''}'),
                        ] else if (item.type == 'credit_card') ...[
                          Text('Card Number: ${item.cardNumber ?? ''}'),
                          Text('Expiry: ${item.cardExpiry ?? ''}'),
                          Text('Holder: ${item.cardHolder ?? ''}'),
                          Text('CVC: ${item.cardCvc ?? ''}'),
                        ] else if (item.type == 'secure_note') ...[
                          Text('Note: ${item.noteContent ?? ''}'),
                        ],
                        if (item.url != null && item.url!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(item.url!),
                          ),
                        Text(item.username),
                        if (item.type == 'basic' ||
                            item.type == 'identity' ||
                            item.type == 'license')
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  isVisible ? item.password : '••••••••',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                tooltip: isVisible
                                    ? 'Hide password'
                                    : 'Show password',
                                onPressed: () {
                                  final map = Map<String, bool>.from(
                                    passwordVisibility,
                                  );
                                  map[item.id] = !isVisible;
                                  ref
                                          .read(
                                            _passwordVisibilityProvider
                                                .notifier,
                                          )
                                          .state =
                                      map;
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                tooltip: 'Copy password',
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: item.password),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Password copied!'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        if (item.notes != null && item.notes!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Icon(Icons.notes, size: 16),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    item.notes!,
                                    style: const TextStyle(fontSize: 13),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    trailing: Text(item.type.toUpperCase()),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            AddEditCredentialScreen(credential: item),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const AddEditCredentialScreen(),
            ),
          );
          ref.invalidate(credentialsNotifierProviderInit);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
