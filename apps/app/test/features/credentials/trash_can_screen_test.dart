import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/src/features/credentials/presentation/trash_can_screen.dart';
import 'package:app/src/features/credentials/application/credentials_notifier.dart';
import 'package:app/src/features/credentials/models/credential.dart';
import 'package:core/core.dart' as core;

class InMemoryCredentialsStorage implements core.CredentialsStorage {
  List<Credential> _items = [];
  @override
  Future<List<Credential>> loadAll() async => _items;
  @override
  Future<void> saveAll(List<Credential> items) async {
    _items = items;
  }
}

void main() {
  testWidgets('TrashCanScreen shows deleted credentials and allows restore', (
    WidgetTester tester,
  ) async {
    final deleted = Credential(
      id: '1',
      title: 'Deleted',
      username: 'user',
      password: 'pass',
      updatedAt: DateTime.now(),
      isDeleted: true,
    );
    final storage = InMemoryCredentialsStorage();
    final notifier = CredentialsNotifier(storage: storage)
      ..replaceAll([deleted]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          credentialsNotifierProvider.overrideWith((ref) => notifier),
        ],
        child: MaterialApp(home: const TrashCanScreen()),
      ),
    );
    expect(find.text('Deleted'), findsOneWidget);
    expect(find.byIcon(Icons.restore), findsOneWidget);
    await tester.tap(find.byIcon(Icons.restore));
    await tester.pump();
    expect(notifier.credentials.first.isDeleted, isFalse);
  });
}
