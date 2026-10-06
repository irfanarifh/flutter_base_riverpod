import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_template/features/settings/data/settings_repository_provider.dart';

part 'theme_mode_controller.g.dart';

/// Controller maintaining and persisting active [ThemeMode].
@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  @override
  ThemeMode build() {
    return ref.watch(settingsRepositoryProvider).getThemeMode();
  }

  /// Updates active theme and persists selection to preferences.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await ref.read(settingsRepositoryProvider).setThemeMode(mode);
  }
}
