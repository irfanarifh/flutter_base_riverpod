import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/app/l10n/app_localizations.dart';
import 'package:flutter_template/app/router/app_router.dart';
import 'package:flutter_template/core/config/env.dart';
import 'package:flutter_template/core/theme/app_theme.dart';
import 'package:flutter_template/features/auth/controller/auth_controller.dart';
import 'package:flutter_template/features/settings/controller/settings_controller.dart';
import 'package:flutter_template/shared/providers/auth_actions_provider.dart';

/// Root application widget configured with GoRouter, theming, and localizations.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeControllerProvider);
    final locale = ref.watch(localeControllerProvider);

    return ProviderScope(
      overrides: [
        logoutActionProvider.overrideWithValue(
          () => ref.read(authControllerProvider.notifier).logout(),
        ),
      ],
      child: MaterialApp.router(
        title: Env.appName,
        debugShowCheckedModeBanner: Env.flavor.isDev,
        routerConfig: router,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
