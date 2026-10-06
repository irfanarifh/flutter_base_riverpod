import 'package:flutter/material.dart';

/// Immutable model holding current user configuration preferences.
class AppSettings {
  const AppSettings({
    required this.themeMode,
    this.locale,
  });

  final ThemeMode themeMode;
  final Locale? locale;
}
