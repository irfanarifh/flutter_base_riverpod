import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_template/features/settings/data/settings_repository_provider.dart';

part 'locale_controller.g.dart';

/// Controller maintaining and persisting active application [Locale].
@Riverpod(keepAlive: true)
class LocaleController extends _$LocaleController {
  @override
  Locale? build() {
    return ref.watch(settingsRepositoryProvider).getLocale();
  }

  /// Updates active locale and persists selection (`null` indicates system default).
  Future<void> setLocale(Locale? locale) async {
    state = locale;
    await ref.read(settingsRepositoryProvider).setLocale(locale);
  }
}
