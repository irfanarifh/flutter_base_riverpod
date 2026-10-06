import 'package:drift/native.dart';
import 'package:flutter_template/core/database/app_database.dart';

/// Creates an isolated, in-memory [AppDatabase] for testing.
AppDatabase createTestDatabase() {
  return AppDatabase.forTesting(NativeDatabase.memory());
}
