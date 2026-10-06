import 'package:flutter/material.dart';
import 'package:flutter_template/core/constants/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository managing user preference persistence in local storage.
class SettingsRepository {
  const SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  /// Loads the persisted [ThemeMode], defaulting to [ThemeMode.system].
  ThemeMode getThemeMode() {
    final raw = _prefs.getString(StorageKeys.themeMode);
    return ThemeMode.values.firstWhere(
      (element) => element.name == raw,
      orElse: () => ThemeMode.system,
    );
  }

  /// Persists the selected [ThemeMode].
  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(StorageKeys.themeMode, mode.name);
  }

  /// Loads the persisted [Locale], or `null` for system default.
  Locale? getLocale() {
    final code = _prefs.getString(StorageKeys.locale);
    if (code == null || code.isEmpty) {
      return null;
    }
    return Locale(code);
  }

  /// Persists the selected [Locale].
  Future<void> setLocale(Locale? locale) async {
    if (locale == null) {
      await _prefs.remove(StorageKeys.locale);
    } else {
      await _prefs.setString(StorageKeys.locale, locale.languageCode);
    }
  }
}
