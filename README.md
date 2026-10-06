# Flutter Base Template

A production-ready, feature-first Flutter base template architected with strict layer boundaries, modern reactive state management using **Riverpod 2.x**, declarative routing via **GoRouter**, offline-first local persistence powered by **Drift**, encapsulated networking via **Dio**, and complete multi-flavor build systems for Android and iOS.

---

## Table of Contents

1. [Overview & Tech Stack](#1-overview--tech-stack)
2. [Requirements](#2-requirements)
3. [Quick Start](#3-quick-start)
4. [Environment (.env) & Security Warning](#4-environment-env--security-warning)
5. [Flavors & Build](#5-flavors--build)
6. [Architecture & Code Conventions](#6-architecture--code-conventions)
7. [Adding a New Feature](#7-adding-a-new-feature)
8. [Removing Drift and the Example Feature](#8-removing-drift-and-the-example-feature)
9. [Standard Conventions](#9-standard-conventions)
10. [Testing](#10-testing)
11. [Renaming the Template for a New Project](#11-renaming-the-template-for-a-new-project)
12. [Launcher Icons & Native Splash Screen](#12-launcher-icons--native-splash-screen)
13. [Replacing MockAuthApi with a Real API](#13-replacing-mockauthapi-with-a-real-api)
14. [Template Readiness Checklist](#14-template-readiness-checklist)

---

## 1. Overview & Tech Stack

This template is designed to accelerate enterprise-scale project kickoffs without compromising performance, readability, or architectural integrity.

- **State Management & DI**: [Riverpod 2.6+](https://riverpod.dev) (`flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`) utilizing modern code-generation annotations (`Notifier`, `AsyncNotifier`, `StreamNotifier`).
- **Routing**: [GoRouter 14.8+](https://pub.dev/packages/go_router) with `StatefulShellRoute.indexedStack`, `refreshListenable`, and automated session-based authentication redirects.
- **Local Database**: [Drift 2.26+](https://drift.simonbinder.eu) (`drift`, `drift_flutter`, `drift_dev`) offline-first SQLite database that is completely modularized with zero coupling to global database accessors.
- **Networking**: [Dio 5.8+](https://pub.dev/packages/dio) with structured interceptors: `AuthInterceptor` (Bearer token injection and automated 401 session expiry handling), `LoggingInterceptor` (sensitive header redaction), and `ErrorInterceptor`.
- **Serialization & Immutability**: [Freezed 2.5+](https://pub.dev/packages/freezed) and `json_serializable`.
- **Storage**: `flutter_secure_storage` (JWT tokens & sensitive credentials) and `shared_preferences` (theme and language preferences).
- **Environment**: `flutter_dotenv` for loading flavor-specific environment variables.
- **Internationalization (i18n)**: Official Flutter `flutter_localizations` with ARB catalogs (`app_en.arb` and `app_id.arb`).
- **Design System**: Material 3 with centralized design tokens (`AppColors`, `AppTextStyles`, `AppSpacing`, `AppRadius`, `AppTheme`).

---

## 2. Requirements

- **Flutter SDK**: `>= 3.24.0` (Latest stable channel recommended)
- **Dart SDK**: `>= 3.5.0 < 4.0.0`
- **Android Studio / Xcode** with respective platform build toolchains installed.

Verify your environment readiness by running:

```bash
flutter doctor
```

---

## 3. Quick Start

Follow these steps to run the application for the first time:

1. **Clone the repository:**

   ```bash
   git clone <repository-url> my_project
   cd my_project
   ```

2. **Copy the environment templates:**

   ```bash
   cp .env.example .env.dev
   cp .env.example .env.staging
   cp .env.example .env.prod
   ```

3. **Install dependencies:**

   ```bash
   flutter pub get
   ```

4. **Run code generation and localization:**

   ```bash
   dart run tool/codegen.dart
   ```

5. **Launch the application (Dev Flavor):**
   ```bash
   flutter run
   ```

---

## 4. Environment (.env) & Security Warning

Environment files are loaded during application bootstrapping through [Env](file:///lib/core/config/env.dart):

- `.env.dev` loaded by default or with `--flavor dev`
- `.env.staging` loaded with `--flavor staging`
- `.env.prod` loaded with `--flavor prod`

> [!WARNING]
> **CRITICAL SECURITY WARNING:**
> The `.env` files are included as Flutter assets (`assets/`) and are therefore bundled directly into the compiled application binary (.apk, .ipa).
> **NEVER** store true secrets such as _Private Keys_, _Database Master Passwords_, _Stripe Secret Keys_, or confidential backend credentials inside `.env` files.
> Public client secrets (such as Base URLs, Google Maps Web Client Keys, Timeouts, Client IDs) are permissible. User credentials or dynamic authentication tokens must be persisted securely using `StorageService` (`flutter_secure_storage`).

---

## 5. Flavors & Build

The application has 3 distinct build flavors configured on both Android and iOS: `dev`, `staging`, and `prod`.

Under the unified entrypoint [`lib/main.dart`](file:///lib/main.dart), Flutter's built-in `appFlavor` constant is populated automatically from the `--flavor` CLI flag. Furthermore, `default-flavor: dev` declared in `pubspec.yaml` enables plain `flutter run` without arguments to default directly to the `dev` flavor.

### Running the Application

```bash
# Development (default flavor via pubspec default-flavor: dev)
flutter run

# Staging
flutter run --flavor staging

# Production
flutter run --flavor prod
```

### Building Release Binaries (Android APK / App Bundle)

```bash
# APK
flutter build apk --flavor dev
flutter build apk --flavor staging
flutter build apk --flavor prod

# Android App Bundle (AAB for Google Play)
flutter build appbundle --flavor prod
```

> [!WARNING]
> **CRITICAL RELEASE BUILD WARNING:**
> **ALWAYS** pass `--flavor prod` for production release builds and CI/CD pipelines (e.g., `flutter build apk --flavor prod` or `flutter build appbundle --flavor prod`). Never ship a build produced without an explicit flavor. If an application binary is executed in release mode without a specified flavor, it will terminate immediately with a `StateError`: `"Release build without --flavor. Use: flutter build <target> --flavor prod"`.

> [!NOTE]
> **Note (Web & Desktop Support):**
> Web and desktop platforms may not populate `appFlavor` through native build schemes in the same way as Android and iOS toolchains. This template primarily targets Android and iOS.

> [!TIP]
> **Per-Flavor Custom Initialization:**
> If a project later requires distinct per-flavor initialization logic (for example, configuring flavor-specific Firebase options via `DefaultFirebaseOptions.currentPlatform`), switch back to separate `lib/main_<flavor>.dart` entrypoint files that call `bootstrap(flavor: ...)`.

### iOS Scheme Verification Checklist

Flutter identifies iOS flavor configurations through corresponding schemes and build configurations:

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select **Product** > **Scheme** > **Manage Schemes...**.
3. Verify that schemes exist matching the exact lowercase flavor names: `dev`, `staging`, and `prod`.
4. Ensure each scheme maps its Run, Test, Profile, and Release actions to the appropriate configurations (`Debug-<flavor>`, `Release-<flavor>`, `Profile-<flavor>`).
5. Ensure the **Shared** box is checked for each scheme so they are preserved in version control under `ios/Runner.xcodeproj/xcshareddata/xcschemes/`.

---

## 6. Architecture & Code Conventions

This project adheres strictly to a **Feature-First** architecture with clear layer segregation:

```
lib/
├── app/                  # Routing, root app shell, bootstrap l10n
│   ├── l10n/             # Compiled AppLocalizations outputs
│   └── router/           # GoRouter config, router observer, shells
├── core/                 # Foundation components with no feature dependencies
│   ├── config/           # Env, Flavor
│   ├── constants/        # AppConstants, StorageKeys
│   ├── database/         # Drift AppDatabase & shared tables
│   ├── errors/           # AppException, Failure, error mappers
│   ├── extensions/       # BuildContext, String, AsyncValue extensions
│   ├── network/          # Dio client, ApiResponse, Interceptors
│   ├── services/         # LoggerService, StorageService
│   ├── theme/            # Design tokens, colors, typography, AppTheme
│   └── utils/            # Validators, formatters, Debouncer
├── features/             # Independent, modular feature domains
│   ├── auth/             # Authentication (User, login, token, controller, views)
│   ├── example/          # Offline-first CRUD sample (Drift, DAO, screens)
│   └── settings/         # Theme toggles, language preferences, logout
├── shared/               # Reusable widgets and cross-feature abstractions
│   ├── models/           # PaginatedResult, Result
│   ├── providers/        # Connectivity, SharedPrefs, AuthActions
│   └── widgets/          # Buttons, inputs, dialogs, layout, AsyncValueWidget
├── bootstrap.dart        # Global entrypoint, zone guards, async init
└── main.dart             # Unified entrypoint with appFlavor & default-flavor
```

### Layer Import Boundary Rules

1. **Dependency Direction**:
   ```
   app -> features -> shared -> core
   ```
2. **Core Isolation**: `lib/core/` **MUST NEVER** import `shared/`, `features/`, or `app/` (the single allowed exception is `AppLocalizations` in `context_extension.dart`).
3. **Feature Isolation**: Features within `lib/features/` **MUST NEVER** import other features directly!
   - Example: `features/settings` is forbidden from importing `features/auth`. When settings triggers a logout action, it utilizes a callback contract or the decoupled shared provider in `lib/shared/providers/auth_actions_provider.dart` (`logoutActionProvider`).
4. **Only `bootstrap.dart` and `main.dart`** are permitted to cross all architectural boundaries for initial startup wiring.

---

## 7. Adding a New Feature

### Using the Automated Tooling Script

Execute the scaffolding utility to create standard feature directory structures:

```bash
dart run tool/new_feature.dart customer_profile
```

This generates:

- `lib/features/customer_profile/model/customer_profile.dart` (Freezed model)
- `lib/features/customer_profile/data/customer_profile_repository.dart`
- `lib/features/customer_profile/controller/customer_profile_controller.dart` (`AsyncNotifier`)
- `lib/features/customer_profile/view/customer_profile_screen.dart`

### Manual Follow-up Steps:

1. Register route constants in `lib/app/router/app_routes.dart`:
   ```dart
   static const String customerProfilePath = '/customer-profile';
   static const String customerProfileName = 'customerProfile';
   ```
2. Register the `GoRoute` in `lib/app/router/app_router.dart`:
   ```dart
   GoRoute(
     path: AppRoutes.customerProfilePath,
     name: AppRoutes.customerProfileName,
     builder: (context, state) => const CustomerProfileScreen(),
   ),
   ```
3. Run code generation:
   ```bash
   dart run tool/codegen.dart
   ```

---

## 8. Removing Drift and the Example Feature

The example feature is completely modular and self-contained. If your project does not require local SQLite persistence (Drift) or the example CRUD sample, follow these clean removal steps:

1. **Delete the example directories:**
   ```bash
   rm -rf lib/features/example/
   rm -rf test/features/example/
   ```
2. **Remove the table from `AppDatabase`:**
   - In `lib/core/database/app_database.dart`, remove `ExampleItems` from `@DriftDatabase(tables: [...])`.
   - Delete `lib/core/database/tables/example_items_table.dart`.
3. **Remove routes from the router:**
   - In `lib/app/router/app_router.dart`, remove routes pointing to `ExampleListScreen` and `ExampleDetailScreen`.
   - In `lib/app/router/app_routes.dart`, delete `examplePath`, `exampleName`, `exampleDetailPath`, `exampleDetailName`.
4. **Remove the tab from the shell navigation:**
   - In `lib/app/router/shell/main_shell.dart`, remove the `NavigationDestination` entry for the Example tab.
5. **Increment `schemaVersion`:**
   - In `lib/core/database/app_database.dart`, bump `schemaVersion` (e.g. from `1` to `2`).
   - _(If removing Drift entirely, delete `lib/core/database/` and remove `drift`, `drift_flutter`, and `drift_dev` from `pubspec.yaml`)._
6. **Re-run code generation:**
   ```bash
   dart run tool/codegen.dart
   ```

---

## 9. Standard Conventions

### Naming Conventions

- **Files & Directories**: `snake_case.dart` (e.g., `auth_repository.dart`, `login_screen.dart`).
- **Classes, Enums, Types**: `PascalCase` (e.g., `AuthController`, `AppColors`).
- **Variables, Methods, Providers**: `camelCase` (e.g., `authControllerProvider`, `getUserProfile()`).
- **Constants**: `camelCase` for Dart objects, `SCREAMING_SNAKE_CASE` for `.env` environment keys.

### Internal File Layout

Files should follow a predictable structure:

1. File header documentation (if applicable).
2. Directives imports (`dart:`, `package:`, relative internal).
3. `part` and `part of` directives (when using code generation).
4. Top-level Provider declarations.
5. Main Class declaration, constructors, public fields, public methods, and private helpers.

### Commit Style (Conventional Commits)

All commit messages should follow the standard format:

```
<type>(<optional scope>): <short description>

[optional body]
```

Supported types:

- `feat`: New feature or user-facing addition.
- `fix`: Bug fix or defect resolution.
- `refactor`: Structural code changes without altering external behavior.
- `test`: Adding or modifying test suites.
- `chore`: Build scripts, dependencies, or repository maintenance.

---

## 10. Testing

The project is equipped with a complete testing suite operating with zero real network or disk access:

### Running Unit & Widget Tests

```bash
# Run all unit and widget tests
flutter test

# Run specific test suites
flutter test test/features/auth/controller/login_controller_test.dart
flutter test test/features/example/data/example_dao_test.dart
flutter test test/features/auth/view/login_screen_test.dart
```

### Running Integration Tests

```bash
# Run on connected mobile device or emulator
flutter test integration_test/app_test.dart -d <device_id>

# Run in Chrome
flutter test integration_test/app_test.dart -d chrome
```

### Overriding Providers in Tests

Utilize the `pumpApp` testing utility from `test/helpers/pump_app.dart`:

```dart
testWidgets('renders screen with mock repository', (tester) async {
  final mockRepo = MockAuthRepository();
  when(() => mockRepo.restoreSession()).thenAnswer((_) async => null);

  await tester.pumpApp(
    child: const LoginScreen(),
    overrides: [
      authRepositoryProvider.overrideWithValue(mockRepo),
    ],
  );
  await tester.pumpAndSettle();

  expect(find.byType(PrimaryButton), findsOneWidget);
});
```

---

## 11. Renaming the Template for a New Project

To rename the project from `flutter_template` to your desired application identifier, run the provided utility script:

```bash
dart run tool/rename_project.dart <package_name> <bundle_id> "<App Name>"
```

**Example:**

```bash
dart run tool/rename_project.dart my_super_app com.company.superapp "My Super App"
```

The script automatically updates:

- `pubspec.yaml`
- All `package:flutter_template/...` imports in `lib/`, `test/`, and `integration_test/`
- Android `applicationId` and `app_name` in `android/app/build.gradle.kts`
- iOS `PRODUCT_BUNDLE_IDENTIFIER` and `APP_DISPLAY_NAME` in project configs
- `APP_NAME` values across all `.env.*` files

After running the script, re-synchronize the project:

```bash
flutter pub get
dart run tool/codegen.dart
flutter test
```

---

## 12. Launcher Icons & Native Splash Screen

This template includes automated generation for multi-platform application launcher icons and native splash screens on Android and iOS.

### Generating Launcher Icons

Launcher icon generation is configured via [`flutter_launcher_icons.yaml`](file:///flutter_launcher_icons.yaml) using the `flutter_launcher_icons` tool.

1. **Source Assets**:
   - `assets/icons/app_icon.png`: Master icon (1024x1024 px) for iOS and standard Android icons.
   - `assets/icons/app_icon_foreground.png`: Foreground icon (1024x1024 px) with safe-zone margins for Android Adaptive Icons.
2. **Execute Generation Command**:
   ```bash
   dart run flutter_launcher_icons
   ```
   *Note: For flavor-specific launcher icons, you can pass custom config files with `-f`:*
   ```bash
   dart run flutter_launcher_icons -f flutter_launcher_icons-dev.yaml
   ```

### Generating Native Splash Screen

Native splash screen generation is configured via [`flutter_native_splash.yaml`](file:///flutter_native_splash.yaml) using `flutter_native_splash`.

1. **Source Assets**:
   - `assets/images/splash.png`: Light mode splash image.
   - `assets/images/splash_dark.png`: Dark mode splash image (Android 12 & iOS dark theme).
2. **Execute Generation Command**:
   ```bash
   dart run flutter_native_splash:create
   ```
   *Note: For flavor-specific splash screens, run with the `--path` option:*
   ```bash
   dart run flutter_native_splash:create --path=flutter_native_splash-dev.yaml
   ```
3. **Framework Lifecycle Wiring**:
   In [`lib/bootstrap.dart`](file:///lib/bootstrap.dart), `FlutterNativeSplash.preserve(...)` holds the splash screen during asynchronous bootstrap initialization (`.env`, `SharedPreferences`), and `FlutterNativeSplash.remove()` releases it immediately after `runApp()`.

---

## 13. Replacing MockAuthApi with a Real API

By default, authentication is backed by `MockAuthApi`, which validates email formats and password lengths locally without requiring network connectivity.

To connect to your live backend service:

1. Open [auth_repository_provider.dart](file:///lib/features/auth/data/auth_repository_provider.dart).
2. Switch the `authApi` instantiation from `MockAuthApi()` to `RealAuthApi`:

   ```dart
   // Change from:
   final AuthApi authApi = MockAuthApi();

   // To:
   final AuthApi authApi = RealAuthApi(ref.watch(dioProvider));
   ```

3. Update endpoint routes in [auth_api.dart](file:///lib/features/auth/data/auth_api.dart) (`/auth/login`, `/auth/me`) to match your backend specification.

---

## 14. Template Readiness Checklist

Before publishing or onboarding your engineering team onto this template, ensure all the following verification checkpoints are met:

- [x] **Flavors**: `dev`, `staging`, and `prod` targets configured for Android and iOS.
- [x] **Network Security**: Dio interceptors automatically redact `Authorization` headers in logs and trigger session invalidation on HTTP 401.
- [x] **Secure Storage**: JWT access and refresh tokens persisted using `FlutterSecureStorage`.
- [x] **Offline Database**: Drift SQLite DAO is completely decoupled and tested with `NativeDatabase.memory()`.
- [x] **Routing**: GoRouter handles reactive auth redirects and bottom navigation state retention via `StatefulShellRoute`.
- [x] **Localization**: UI text is localized with ARB catalogs (`en` and `id`) via `context.l10n`.
- [x] **Theme System**: Material 3 with persistent system, light, and dark mode toggles.
- [x] **Branding**: Launcher icons and native splash screens configured and generated for Android and iOS.
- [x] **Testing**: 100% deterministic unit, widget, and integration tests passing.
- [x] **Static Analysis**: `flutter analyze` produces **0 warnings** and **0 errors**.
- [x] **Automated Tooling**: `tool/codegen.dart`, `tool/new_feature.dart`, and `tool/rename_project.dart` cross-platform scripts tested and operational.
