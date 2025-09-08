import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/credentials_notifier.dart';
import '../models/credential.dart';
import '../application/search_sort.dart';
import 'add_edit_credential_screen.dart';

// Use the notifier provider for state management

class CredentialsScreen extends ConsumerWidget {
  const CredentialsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Credential> items = ref.watch(filteredSortedCredentialsProvider);
    final CredentialsSortMode sortMode = ref.watch(credentialsSortModeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vault'),
        actions: <Widget>[
          PopupMenuButton<CredentialsSortMode>(
            initialValue: sortMode,
            onSelected: (CredentialsSortMode value) =>
                ref.read(credentialsSortModeProvider.notifier).state = value,
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<CredentialsSortMode>>[
                  const PopupMenuItem<CredentialsSortMode>(
                    value: CredentialsSortMode.updatedDesc,
                    child: Text('Sort: Recently Updated'),
                  ),
                  const PopupMenuItem<CredentialsSortMode>(
                    value: CredentialsSortMode.nameAsc,
                    child: Text('Sort: Name A→Z'),
                  ),
                  const PopupMenuItem<CredentialsSortMode>(
                    value: CredentialsSortMode.nameDesc,
                    child: Text('Sort: Name Z→A'),
                  ),
                ],
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.only(top: 8),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (BuildContext context, int index) {
          final Credential item = items[index];
          return Dismissible(
            key: ValueKey<String>(item.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Theme.of(context).colorScheme.error,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => ref
                .read(credentialsNotifierProvider.notifier)
                .removeCredentialById(item.id),
            child: ListTile(
              title: Text(item.title),
              subtitle: Text(item.username),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => AddEditCredentialScreen(credential: item),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const AddEditCredentialScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          onChanged: (String v) =>
              ref.read(credentialsSearchQueryProvider.notifier).state = v,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search credentials',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
