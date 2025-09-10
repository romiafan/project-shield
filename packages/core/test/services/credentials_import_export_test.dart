import 'package:test/test.dart';
import 'package:core/src/services/credentials_import_export.dart';
import 'package:core/src/models/credential.dart';

void main() {
  group('CredentialsImportExport', () {
    test('export and import credentials to/from JSON', () {
      final now = DateTime.now();
      final credentials = [
        Credential(
          id: '1',
          title: 'Email',
          username: 'user@example.com',
          password: 'pass123',
          updatedAt: now,
          isDeleted: false,
        ),
        Credential(
          id: '2',
          title: 'Bank',
          username: 'bankuser',
          password: 'secure!',
          updatedAt: now,
          isDeleted: true,
        ),
        Credential(
          id: '3',
          title: 'TOTP',
          username: '',
          password: '',
          updatedAt: now,
          type: 'totp',
          totpSecret: 'JBSWY3DPEHPK3PXP',
          totpDigits: 6,
          totpPeriod: 30,
        ),
        Credential(
          id: '4',
          title: 'Passkey',
          username: '',
          password: '',
          updatedAt: now,
          type: 'passkey',
          passkeyCredentialId: 'credid123',
          passkeyPublicKey: 'publickey456',
        ),
        Credential(
          id: '5',
          title: 'Card',
          username: '',
          password: '',
          updatedAt: now,
          type: 'credit_card',
          cardNumber: '4111111111111111',
          cardExpiry: '12/25',
          cardHolder: 'John Doe',
          cardCvc: '123',
        ),
        Credential(
          id: '6',
          title: 'Note',
          username: '',
          password: '',
          updatedAt: now,
          type: 'secure_note',
          noteContent: 'This is a secure note.',
        ),
      ];
      final json = CredentialsImportExport.exportToJson(credentials);
      final imported = CredentialsImportExport.importFromJson(json);
      expect(imported.length, credentials.length);
      expect(imported[2].type, 'totp');
      expect(imported[2].totpSecret, 'JBSWY3DPEHPK3PXP');
      expect(imported[3].type, 'passkey');
      expect(imported[3].passkeyCredentialId, 'credid123');
      expect(imported[4].type, 'credit_card');
      expect(imported[4].cardNumber, '4111111111111111');
      expect(imported[5].type, 'secure_note');
      expect(imported[5].noteContent, 'This is a secure note.');
    });

    test('import from invalid JSON throws', () {
      expect(
        () => CredentialsImportExport.importFromJson('not a json'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
