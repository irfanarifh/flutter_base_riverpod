import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_template/core/constants/storage_keys.dart';

class StorageService {
  const StorageService(this._storage);

  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token) async {
    await _storage.write(key: StorageKeys.authToken, value: token);
  }

  Future<String?> readToken() async {
    return _storage.read(key: StorageKeys.authToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: StorageKeys.authToken);
  }

  /// Caches the last known user (JSON) so the session survives offline starts.
  Future<void> saveUserJson(String json) async {
    await _storage.write(key: StorageKeys.authUser, value: json);
  }

  Future<String?> readUserJson() async {
    return _storage.read(key: StorageKeys.authUser);
  }

  Future<void> deleteUserJson() async {
    await _storage.delete(key: StorageKeys.authUser);
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );
  return const StorageService(secureStorage);
});
