import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/config/env.dart';
import 'package:flutter_template/core/network/api_manager.dart';
import 'package:flutter_template/core/services/storage_service.dart';
import 'package:flutter_template/features/auth/data/auth_api.dart';
import 'package:flutter_template/features/auth/data/auth_repository.dart';

/// Exposes [AuthRepository], switching between MockAuthApi and RealAuthApi via USE_MOCK_API.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final AuthApi authApi = Env.useMockApi ? MockAuthApi() : RealAuthApi(ref.watch(apiManagerProvider));

  return AuthRepository(
    authApi: authApi,
    storageService: ref.watch(storageServiceProvider),
  );
});
