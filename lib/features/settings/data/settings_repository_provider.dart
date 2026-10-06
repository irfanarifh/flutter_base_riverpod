import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/features/settings/data/settings_repository.dart';
import 'package:flutter_template/shared/providers/shared_prefs_provider.dart';

/// Exposes the [SettingsRepository] singleton instance.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return SettingsRepository(prefs);
});
