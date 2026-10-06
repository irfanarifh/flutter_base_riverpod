import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/database/app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.keepAlive();
  ref.onDispose(() => db.close());
  return db;
});
