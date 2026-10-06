import 'package:flutter_template/core/services/logger_service.dart';
import 'package:flutter_template/core/services/storage_service.dart';
import 'package:flutter_template/features/auth/data/auth_repository.dart';
import 'package:flutter_template/features/auth/model/login_request.dart';
import 'package:flutter_template/features/auth/model/user.dart';
import 'package:flutter_template/features/example/data/example_repository.dart';
import 'package:flutter_template/features/example/model/example_item.dart';
import 'package:mocktail/mocktail.dart';

/// Mock of [AuthRepository] for authentication testing.
class MockAuthRepository extends Mock implements AuthRepository {}

/// Mock of [ExampleRepository] for example feature testing.
class MockExampleRepository extends Mock implements ExampleRepository {}

/// Mock of [StorageService] for secure storage testing.
class MockStorageService extends Mock implements StorageService {}

/// Mock of [LoggerService] for logging verification in tests.
class MockLoggerService extends Mock implements LoggerService {}

/// Fallback fake for [User].
class FakeUser extends Fake implements User {}

/// Fallback fake for [LoginRequest].
class FakeLoginRequest extends Fake implements LoginRequest {}

/// Fallback fake for [ExampleItem].
class FakeExampleItem extends Fake implements ExampleItem {}

/// Registers mocktail fallback values required for parameter matching.
void setupMocks() {
  registerFallbackValue(FakeUser());
  registerFallbackValue(FakeLoginRequest());
  registerFallbackValue(FakeExampleItem());
}

/// Standard test fixtures.
abstract final class TestFixtures {
  static const testUser = User(
    id: 'user_123',
    email: 'test@example.com',
    name: 'Test User',
  );

  static final testItem = ExampleItem(
    id: 1,
    title: 'Test Title',
    note: 'Test Note description',
    createdAt: DateTime(2026, 1, 1, 12, 0),
    updatedAt: DateTime(2026, 1, 1, 12, 0),
  );
}
