import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/config/env.dart';
import 'package:flutter_template/core/network/dio_provider.dart';
import 'package:flutter_template/core/services/storage_service.dart';
import 'package:flutter_template/features/auth/data/auth_api.dart';
import 'package:flutter_template/features/auth/data/auth_repository.dart';

/// Exposes the [AuthRepository] singleton instance.
///
/// The data source is chosen by `USE_MOCK_API` in the flavor `.env` file:
/// `true` uses [MockAuthApi], `false` uses [RealAuthApi] against `BASE_URL`.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final AuthApi authApi = Env.useMockApi ? MockAuthApi() : RealAuthApi(ref.watch(dioProvider));

  return AuthRepository(
    authApi: authApi,
    storageService: ref.watch(storageServiceProvider),
  );
});
