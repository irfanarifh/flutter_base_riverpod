import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_template/app/l10n/app_localizations.dart';
import 'package:flutter_template/core/theme/app_theme.dart';

/// Extension on [WidgetTester] providing standard environment bootstrapping
/// with Riverpod [ProviderScope], Material 3 [AppTheme], and localized strings.
extension PumpApp on WidgetTester {
  /// Pumps the widget tree configured with standard app delegates and optional overrides.
  Future<void> pumpApp({
    Widget? child,
    GoRouter? router,
    List<Override> overrides = const [],
    Locale locale = const Locale('en'),
  }) async {
    if (!dotenv.isInitialized) {
      dotenv.testLoad(
        fileInput: 'FLAVOR=dev\nAPP_NAME=Flutter Template\nBASE_URL=https://api.example.com\nENABLE_LOGGING=false\nCONNECT_TIMEOUT_MS=15000\n',
      );
    }

    final Widget root;

    if (router != null) {
      root = MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.lightTheme,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
    } else {
      root = MaterialApp(
        theme: AppTheme.lightTheme,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child ?? const SizedBox.shrink(),
      );
    }

    await pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: root,
      ),
    );

    await pump();
  }
}

/// Standalone helper function forwarding to [PumpApp.pumpApp].
Future<void> pumpApp(
  WidgetTester tester, {
  Widget? child,
  GoRouter? router,
  List<Override> overrides = const [],
  Locale locale = const Locale('en'),
}) {
  return tester.pumpApp(
    child: child,
    router: router,
    overrides: overrides,
    locale: locale,
  );
}
