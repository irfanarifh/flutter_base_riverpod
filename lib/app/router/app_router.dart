import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_template/app/router/app_routes.dart';
import 'package:flutter_template/app/router/router_observer.dart';
import 'package:flutter_template/app/router/shell/main_shell.dart';
import 'package:flutter_template/core/services/logger_service.dart';
import 'package:flutter_template/features/auth/controller/auth_controller.dart';
import 'package:flutter_template/features/auth/view/login_screen.dart';
import 'package:flutter_template/features/example/view/example_detail_screen.dart';
import 'package:flutter_template/features/example/view/example_list_screen.dart';
import 'package:flutter_template/features/settings/view/settings_screen.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refreshNotifier = ValueNotifier<bool>(false);

  ref.listen(authControllerProvider, (_, __) {
    refreshNotifier.value = !refreshNotifier.value;
  });
  ref.onDispose(refreshNotifier.dispose);

  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.examplePath,
    refreshListenable: refreshNotifier,
    observers: [
      RouterObserver(ref.watch(loggerServiceProvider)),
    ],
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      if (authState.isLoading) {
        return null;
      }

      final isLoggedIn = authState.valueOrNull != null;
      final isLoggingIn = state.matchedLocation == AppRoutes.loginPath;

      if (!isLoggedIn) {
        return isLoggingIn ? null : AppRoutes.loginPath;
      }

      if (isLoggingIn) {
        return AppRoutes.examplePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.loginName,
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.examplePath,
                name: AppRoutes.exampleName,
                builder: (context, state) => const ExampleListScreen(),
                routes: [
                  GoRoute(
                    path: AppRoutes.exampleDetailPath,
                    name: AppRoutes.exampleDetailName,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return ExampleDetailScreen(id: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settingsPath,
                name: AppRoutes.settingsName,
                builder: (context, state) => SettingsScreen(
                  onLogout: () => ref.read(authControllerProvider.notifier).logout(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
