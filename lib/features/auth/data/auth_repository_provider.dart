import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/services/storage_service.dart';
import 'package:flutter_template/features/auth/data/auth_api.dart';
import 'package:flutter_template/features/auth/data/auth_repository.dart';

/// Exposes the [AuthRepository] singleton instance.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // TOGGLE: Switch to RealAuthApi(ref.watch(dioProvider)) to consume live backend.
  final AuthApi authApi = MockAuthApi();

  return AuthRepository(
    authApi: authApi,
    storageService: ref.watch(storageServiceProvider),
  );
});
