import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for [SharedPreferences].
///
/// This provider must be overridden in [ProviderScope] during application
/// bootstrap. It is kept alive by default and throws [UnimplementedError]
/// if accessed before initialization.
final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPrefsProvider must be overridden in ProviderScope during bootstrap.',
  );
});
