import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/credentials_notifier.dart';

class TrashCanScreen extends ConsumerWidget {
  const TrashCanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trashed = ref
        .watch(credentialsNotifierProvider)
        .where((c) => c.isDeleted)
        .toList();
    final notifier = ref.read(credentialsNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Trash Can')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: trashed.isEmpty
            ? const Center(child: Text('No deleted credentials'))
            : ListView.builder(
                itemCount: trashed.length,
                itemBuilder: (context, i) {
                  final cred = trashed[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(cred.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (cred.type == 'totp') ...[
                            Text('TOTP Secret: ${cred.totpSecret ?? ''}'),
                            Text('Digits: ${cred.totpDigits ?? ''}'),
                            Text('Period: ${cred.totpPeriod ?? ''}'),
                          ] else if (cred.type == 'passkey') ...[
                            Text(
                              'Passkey ID: ${cred.passkeyCredentialId ?? ''}',
                            ),
                            Text('Public Key: ${cred.passkeyPublicKey ?? ''}'),
                          ] else if (cred.type == 'credit_card') ...[
                            Text('Card Number: ${cred.cardNumber ?? ''}'),
                            Text('Expiry: ${cred.cardExpiry ?? ''}'),
                            Text('Holder: ${cred.cardHolder ?? ''}'),
                            Text('CVC: ${cred.cardCvc ?? ''}'),
                          ] else if (cred.type == 'secure_note') ...[
                            Text('Note: ${cred.noteContent ?? ''}'),
                          ],
                          if (cred.url != null && cred.url!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(cred.url!),
                            ),
                          Text(cred.username),
                          if (cred.notes != null && cred.notes!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Icon(Icons.notes, size: 16),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      cred.notes!,
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(cred.type.toUpperCase()),
                          IconButton(
                            icon: const Icon(Icons.restore),
                            tooltip: 'Restore',
                            onPressed: () {
                              notifier.restoreCredentialById(cred.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Credential restored!'),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever),
                            tooltip: 'Delete Forever',
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Permanently'),
                                  content: const Text(
                                    'Are you sure you want to permanently delete this credential? This cannot be undone.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                notifier.deleteForeverById(cred.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Credential deleted forever!',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
