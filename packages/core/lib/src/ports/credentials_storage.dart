import '../models/credential.dart';

abstract class CredentialsStorage {
  Future<List<Credential>> loadAll();
  Future<void> saveAll(List<Credential> items);
}
