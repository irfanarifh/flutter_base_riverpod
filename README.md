# Flutter Base Template

A production-ready, feature-first Flutter base template architected with strict layer boundaries, modern reactive state management using **Riverpod 2.x**, declarative routing via **GoRouter**, offline-first local persistence powered by **Drift**, encapsulated networking via **Dio**, and complete multi-flavor build systems for Android and iOS.

---

## Table of Contents

1. [Overview & Tech Stack](#1-overview--tech-stack)
2. [Requirements](#2-requirements)
3. [Quick Start (Running the Template As-Is)](#3-quick-start-running-the-template-as-is)
4. [Starting a New App from This Base](#4-starting-a-new-app-from-this-base)
5. [Environment (.env) & Security Warning](#5-environment-env--security-warning)
6. [Flavors & Build](#6-flavors--build)
7. [Architecture & Code Conventions](#7-architecture--code-conventions)
8. [Adding a New Feature](#8-adding-a-new-feature)
9. [Removing Drift and the Example Feature](#9-removing-drift-and-the-example-feature)
10. [Standard Conventions](#10-standard-conventions)
11. [Testing](#11-testing)
12. [Renaming the Template for a New Project](#12-renaming-the-template-for-a-new-project)
13. [Launcher Icons & Native Splash Screen](#13-launcher-icons--native-splash-screen)
14. [Replacing MockAuthApi with a Real API](#14-replacing-mockauthapi-with-a-real-api)
15. [Template Readiness Checklist](#15-template-readiness-checklist)
16. [NPM Scripts Reference](#16-npm-scripts-reference)

---

## 1. Overview & Tech Stack

This template is designed to accelerate enterprise-scale project kickoffs without compromising performance, readability, or architectural integrity.

- **State Management & DI**: [Riverpod 3.x](https://riverpod.dev) (`flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`) utilizing modern code-generation annotations (`Notifier`, `AsyncNotifier`, `StreamNotifier`).
- **Routing**: [GoRouter 18.x](https://pub.dev/packages/go_router) with `StatefulShellRoute.indexedStack`, `refreshListenable`, and automated session-based authentication redirects.
- **Local Database**: [Drift 2.31+](https://drift.simonbinder.eu) (`drift`, `drift_flutter`, `drift_dev`) offline-first SQLite database that is completely modularized with zero coupling to global database accessors.
- **Networking**: [Dio 5.11+](https://pub.dev/packages/dio) with structured interceptors: `AuthInterceptor` (Bearer token injection and automated 401 session expiry handling), `LoggingInterceptor` (sensitive header redaction), and `ErrorInterceptor`.
- **Serialization & Immutability**: [Freezed 3.x](https://pub.dev/packages/freezed) and `json_serializable`.
- **Storage**: `flutter_secure_storage` (JWT tokens & sensitive credentials) and `shared_preferences` (theme and language preferences).
- **Environment**: `flutter_dotenv` for loading flavor-specific environment variables.
- **Internationalization (i18n)**: Official Flutter `flutter_localizations` with ARB catalogs (`app_en.arb` and `app_id.arb`).
- **Design System**: Material 3 with centralized design tokens (`AppColors`, `AppTextStyles`, `AppSpacing`, `AppRadius`, `AppTheme`).

---

## 2. Requirements

- **Flutter SDK**: `>= 3.47.0` (Required by `google_fonts` 9.0.0; latest stable channel recommended)
- **Dart SDK**: `>= 3.13.0 < 4.0.0` (Required by `google_fonts` 9.0.0)
- **Android Studio / Xcode** with respective platform build toolchains installed.

Verify your environment readiness by running:

```bash
flutter doctor
```

---

## 3. Quick Start (Running the Template As-Is)

Use these steps if you only want to run the base template locally to explore the code, inspect the architecture, or test the built-in demo feature:

1. **Clone the repository:**

   ```bash
   git clone <repository-url> my_project
   cd my_project
   ```

2. **Check the environment files:**

   `.env.dev`, `.env.staging`, and `.env.prod` are committed (see section 5), so a
   fresh clone runs as-is. Edit `BASE_URL` and `APP_NAME` per flavor.
   `.env.example` documents every supported key. Per-developer overrides go in
   `.env.local` (git-ignored).

3. **Install dependencies:**

   ```bash
   npm run get    # or: flutter pub get
   ```

4. **Run code generation and localization:**

   ```bash
   npm run codegen    # or: dart run tool/codegen.dart
   ```

5. **Launch the application (Dev Flavor):**
   ```bash
   npm run dev    # or: flutter run
   ```

---

## 4. Starting a New App from This Base

When cloning this repository to build a **brand-new application**, follow this sequential checklist:

### Step 1: Clone and Re-initialize Git Remote
Clone the base repository, point `origin` to your own remote repository, and adopt your new repository's target branch:

```bash
git clone <template-repository-url> my_new_app
cd my_new_app

# Point origin to your newly created repository
git remote set-url origin <your-new-repository-url>

# Fetch branches and metadata from your new remote
git fetch

# Inspect local branches (check your current template branch, e.g. 'main')
git branch

# Switch to your new remote's branch (adjust 'master' to match your new repo's branch)
git switch master

# Restore/copy all template files from the template branch into your new repo branch
# (adjust '--source=main' to match your template's branch name)
git restore --source=main --staged --worktree .

# Delete the template's local branch (adjust 'main' to match your template's branch name)
git branch -D main
```

> [!TIP]
> **Branch Name Flexibility:**
> The branch names above (`main` for template repo, `master` for new repo) are illustrative examples. Adjust them to match your actual repositories:
> - **Template on `master` and new repo on `main`**: use `git switch main`, `git restore --source=master --staged --worktree .`, and `git branch -D master`.
> - **Both repos share the same branch name** or the new remote is completely empty (no initial commit): you can skip `restore` and simply push directly with `git push -u origin <branch-name>`.

### Step 2: Rename Identifiers & Package Name
Run the automated renaming utility to rebrand the package name, application display name, and bundle identifiers (Android & iOS):

```bash
# If Android and iOS share the same bundle ID (iOS defaults to the Android ID):
npm run rename my_new_app "My New App" com.company.mynewapp

# If Android and iOS use different bundle IDs (pass iOS bundle ID as 4th argument):
npm run rename my_new_app "My New App" com.company.androidapp com.company.iosapp

# Optional flags: --dry-run (simulation), --yes (skip prompt), --force (bypass git check)
npm run rename my_new_app "My New App" com.company.mynewapp -- --dry-run
```

### Step 3: Configure Environment Variables
Update the `.env.*` configuration files with your project's backend details:
1. Edit `BASE_URL` in `.env.dev`, `.env.staging`, and `.env.prod`.
2. When ready to connect to your live backend API, toggle `USE_MOCK_API=false` in `.env.dev` (already defaults to `false` in release mode).
3. If developers need local overrides without committing, place them in `.env.local` (automatically git-ignored).

### Step 4: Customize Branding (Icons & Splash Screen)
1. **App Icons**:
   - Replace `assets/icons/app_icon.png` (1024x1024 master icon).
   - Replace `assets/icons/app_icon_foreground.png` (Android adaptive icon foreground).
   - Generate native icons:
     ```bash
     npm run icons   # or: dart run flutter_launcher_icons
     ```
2. **Splash Screens**:
   - Replace `assets/images/splash.png` (light mode) and `assets/images/splash_dark.png` (dark mode).
   - Generate native splash screens:
     ```bash
     npm run splash   # or: dart run flutter_native_splash:create
     ```

### Step 5: Clean, Regenerate Code & Verify
Synchronize dependencies, generate required boilerplate (`build_runner` and `l10n`), and verify that all test suites pass:

```bash
npm run fresh   # executes: flutter clean && flutter pub get && dart run tool/codegen.dart
npm test        # verify that all unit and widget tests pass (100% pass rate)
```

### Step 6: Clean Up Example Code & Start Developing
1. **(Optional) Remove Example Feature**:
   If your app does not need the CRUD sample or Drift SQLite database, follow [Section 9 (Removing Drift and the Example Feature)](#9-removing-drift-and-the-example-feature) to remove `lib/features/example/`.
2. **Scaffold Your First Feature**:
   Create a new feature module using the scaffolding generator:
   ```bash
   npm run feature my_feature_name
   ```
3. **Launch the App**:
   ```bash
   npm run dev    # or: flutter run --flavor dev
   ```

---

## 5. Environment (.env) & Security Warning

Environment files are loaded during application bootstrapping through [Env](file:///lib/core/config/env.dart):

- `.env.dev` loaded by default or with `--flavor dev`
- `.env.staging` loaded with `--flavor staging`
- `.env.prod` loaded with `--flavor prod`

Each file is registered as a **per-flavor asset** in `pubspec.yaml`, so a build only
bundles its own `.env` (the prod APK does not contain `.env.dev`).

| Key | Purpose |
|---|---|
| `FLAVOR` | Must match the flavor passed to `bootstrap`; a mismatch throws in release |
| `APP_NAME` | Display name used in the UI |
| `BASE_URL` | API base URL (required) |
| `ENABLE_LOGGING` | `true` enables logs (passwords and tokens are redacted) |
| `CONNECT_TIMEOUT_MS` | Dio connect/send/receive timeout |
| `USE_MOCK_API` | `true` = `MockAuthApi`, `false` = real backend. Defaults to `true` in debug and `false` in release |

> [!WARNING]
> **CRITICAL SECURITY WARNING:**
> The `.env` files are included as Flutter assets (`assets/`) and are therefore bundled directly into the compiled application binary (.apk, .ipa).
> **NEVER** store true secrets such as _Private Keys_, _Database Master Passwords_, _Stripe Secret Keys_, or confidential backend credentials inside `.env` files.
> Public client secrets (such as Base URLs, Google Maps Web Client Keys, Timeouts, Client IDs) are permissible. User credentials or dynamic authentication tokens must be persisted securely using `StorageService` (`flutter_secure_storage`).

---

## 6. Flavors & Build

The application has 3 distinct build flavors configured on both Android and iOS: `dev`, `staging`, and `prod`.

Under the unified entrypoint [`lib/main.dart`](file:///lib/main.dart), Flutter's built-in `appFlavor` constant is populated automatically from the `--flavor` CLI flag. Furthermore, `default-flavor: dev` declared in `pubspec.yaml` enables plain `flutter run` without arguments to default directly to the `dev` flavor.

### Running the Application

Using **npm scripts** (recommended):

```bash
# Development (dev flavor)
npm run dev

# Staging
npm run staging

# Production
npm run prod
```

Or using native Flutter CLI:

```bash
# Development (default flavor via pubspec default-flavor: dev)
flutter run

# Staging
flutter run --flavor staging

# Production
flutter run --flavor prod
```

### Building Release Binaries (Android APK / App Bundle / iOS)

Using **npm scripts**:

```bash
# APK
npm run build           # default: flavor prod
npm run build:dev
npm run build:staging
npm run build:prod

# Android App Bundle (AAB for Google Play)
npm run build:aab

# iOS
npm run build:ipa
```

Or using native Flutter CLI:

```bash
# APK
flutter build apk --flavor dev
flutter build apk --flavor staging
flutter build apk --flavor prod --obfuscate --split-debug-info=build/symbols

# Android App Bundle (AAB for Google Play)
flutter build appbundle --flavor prod --obfuscate --split-debug-info=build/symbols

# iOS
flutter build ipa --flavor prod --obfuscate --split-debug-info=build/symbols
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

> [!IMPORTANT]
> The repository ships `ios/Flutter/{Dev,Staging,Prod}.xcconfig`, but the Xcode
> project still has only the default `Runner` scheme and the `Debug`/`Release`/`Profile`
> configurations. Until the schemes and `Debug-<flavor>` / `Release-<flavor>` /
> `Profile-<flavor>` configurations below are created, `flutter run --flavor dev`
> works on **Android only**.

Flutter identifies iOS flavor configurations through corresponding schemes and build configurations:

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select **Product** > **Scheme** > **Manage Schemes...**.
3. Verify that schemes exist matching the exact lowercase flavor names: `dev`, `staging`, and `prod`.
4. Ensure each scheme maps its Run, Test, Profile, and Release actions to the appropriate configurations (`Debug-<flavor>`, `Release-<flavor>`, `Profile-<flavor>`).
5. Ensure the **Shared** box is checked for each scheme so they are preserved in version control under `ios/Runner.xcodeproj/xcshareddata/xcschemes/`.

---

## 7. Architecture & Code Conventions

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

## 8. Adding a New Feature

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

## 9. Removing Drift and the Example Feature

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

## 10. Standard Conventions

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

## 11. Testing

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

## 12. Renaming the Template for a New Project

To rename the project from `flutter_template` to your desired application identifier, run the provided utility script:

```bash
dart run tool/rename_project.dart <package_name> "<App Name>" <android_id> [ios_bundle_id] [--yes] [--dry-run] [--force]
```

**Flags:**
- `--dry-run`: Simulates all file modifications and directory moves without writing any changes to disk.
- `--yes`: Non-interactive execution; skips the confirmation prompt.
- `--force`: Allows execution even if the Git working tree has uncommitted modifications.

**Examples:**

```bash
# 1. Same identifier for Android and iOS (iOS defaults to the Android ID):
dart run tool/rename_project.dart my_super_app "My Super App" com.company.superapp

# 2. Distinct identifiers for Android and iOS:
dart run tool/rename_project.dart my_super_app "My Super App" com.company.androidapp com.company.iosapp

# 3. Dry-run simulation:
dart run tool/rename_project.dart my_super_app "My Super App" com.company.superapp --dry-run
```

The script automatically detects current identifiers dynamically and updates:

- `pubspec.yaml` (package name)
- All `package:<old_pkg>/...` imports in `lib/`, `test/`, `integration_test/`, and `tool/`
- Android `namespace`, `applicationId`, and per-flavor `app_name` in `android/app/build.gradle.kts`
- Android `MainActivity` file location and package declaration (`android/app/src/*/kotlin|java`)
- iOS `PRODUCT_BUNDLE_IDENTIFIER` (in `project.pbxproj`), `CFBundleName`, `CFBundleDisplayName` (in `Info.plist`), and `APP_DISPLAY_NAME` in `ios/Flutter/{Dev,Staging,Prod}.xcconfig`
- `APP_NAME` values across all `.env.*` files (preserving `(Dev)` and `(Staging)` suffixes)
- `name` and `description` in `package.json`
- Scans all files for old leftovers upon completion

After running the script, re-synchronize and validate the project in one command:

```bash
# In one step (flutter clean -> pub get -> codegen -> analyze -> test)
dart run tool/sync.dart
# Or via npm
npm run sync
```

Or execute the steps individually:

```bash
flutter clean
flutter pub get
dart run tool/codegen.dart
flutter analyze
flutter test
```

---

## 13. Launcher Icons & Native Splash Screen

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
   In [`lib/bootstrap.dart`](file:///lib/bootstrap.dart), `FlutterNativeSplash.preserve(...)` holds the splash screen during asynchronous initialization (`.env`, `SharedPreferences`). It is released through `SplashGuard.remove()` (called once) by [`App`](file:///lib/app/app.dart) as soon as the stored session has been restored, so the user never sees an empty frame before the router redirect. `bootstrap` also calls it after 8 seconds and when initialization fails (a minimal error screen is shown instead).

---

## 14. Replacing MockAuthApi with a Real API

By default (debug), authentication is backed by `MockAuthApi`, which validates email format and a 6+ character password locally without any network access.

To use your live backend:

1. Set `USE_MOCK_API=false` in the flavor's `.env` file (it is already `false` by default in release builds).
2. Update the endpoint routes in [auth_api.dart](file:///lib/features/auth/data/auth_api.dart) (`/auth/login`, `/auth/me`) to match your backend.

### API response envelope

The template assumes every backend response looks like this:

```json
{ "code": "1", "message": "Success", "data": { } }
```

| `code` | Meaning | Handling |
|---|---|---|
| `1` | Success | `data` is returned |
| `-99` | Unauthenticated | `AuthInterceptor` clears the token and triggers logout |
| anything else | Failure | `ApiResponseInterceptor` rejects it as `ServerException(code, message)` |

HTTP 200 with a failing `code` is therefore an error, not a success. In API classes read the payload with the `unwrap` helper instead of touching `response.data` directly:

```dart
final response = await _dio.get<Map<String, dynamic>>('/items');
return response.unwrap(
  (json) => (json! as List).map((e) => Item.fromJson(e as Map<String, dynamic>)).toList(),
);
```

Use `response.ensureSuccess()` for calls without a `data` payload. If your backend uses other codes, change the constants in [api_response.dart](file:///lib/core/network/api_response.dart) in one place.

### Session behavior

- On startup the stored token is verified with `/auth/me`.
- If the server rejects the token, the session is cleared.
- If the request fails for any other reason (offline, timeout, server down), the token is **kept** and the last cached user is used, so the app stays usable offline.
- If fetching the profile fails right after login, the freshly saved token is removed again.

---

## 15. Template Readiness Checklist

Before publishing or onboarding your engineering team onto this template, ensure all the following verification checkpoints are met:

- [x] **Flavors (Android)**: `dev`, `staging`, and `prod` product flavors configured.
- [ ] **Flavors (iOS)**: create the schemes and build configurations in Xcode (see section 6).
- [x] **Network Security**: Dio logs redact `Authorization` headers and sensitive JSON fields (`password`, `token`, ...); HTTP 401 and code `-99` trigger session invalidation.
- [x] **Secure Storage**: JWT access and refresh tokens persisted using `FlutterSecureStorage`.
- [x] **Offline Database**: Drift SQLite DAO is completely decoupled and tested with `NativeDatabase.memory()`.
- [x] **Routing**: GoRouter handles reactive auth redirects and bottom navigation state retention via `StatefulShellRoute`.
- [x] **Localization**: UI text is localized with ARB catalogs (`en` and `id`) via `context.l10n`.
- [x] **Theme System**: Material 3 with persistent system, light, and dark mode toggles.
- [x] **Branding**: Launcher icons and native splash screens configured and generated for Android and iOS.
- [x] **Testing**: run `flutter test` and confirm everything passes.
- [x] **Static Analysis**: run `flutter analyze` and confirm 0 warnings and 0 errors.
- [ ] **Automated Tooling**: `tool/codegen.dart` and `tool/new_feature.dart` operational; `tool/rename_project.dart` requires end-to-end verification.

---

## 16. NPM Scripts Reference

For convenience, [`package.json`](file:///package.json) provides unified shortcut scripts for common Flutter and Dart workflows.

Run `npm run` without arguments in your terminal to see the full list of available scripts.

### Application Execution

| Script | Command | Description |
|---|---|---|
| `npm run dev` | `flutter run --flavor dev` | Runs the application in development flavor (debug mode with Hot Reload) |
| `npm run staging` | `flutter run --flavor staging` | Runs the application in staging flavor |
| `npm run prod` | `flutter run --flavor prod` | Runs the application in production flavor |
| `npm start` | `flutter run` | Runs the application with default flavor (`dev`) |

### Production & Release Builds

| Script | Command | Description |
|---|---|---|
| `npm run build` | `flutter build apk --flavor prod --obfuscate --split-debug-info=build/symbols` | Builds production release APK with code obfuscation |
| `npm run build:dev` | `flutter build apk --flavor dev` | Builds development release APK (unobfuscated for debugging) |
| `npm run build:staging` | `flutter build apk --flavor staging` | Builds staging release APK |
| `npm run build:prod` | `flutter build apk --flavor prod --obfuscate --split-debug-info=build/symbols` | Builds production release APK with code obfuscation |
| `npm run build:aab` | `flutter build appbundle --flavor prod --obfuscate --split-debug-info=build/symbols` | Builds production Android App Bundle with code obfuscation (Google Play) |
| `npm run build:ipa` | `flutter build ipa --flavor prod --obfuscate --split-debug-info=build/symbols` | Builds production iOS archive (.ipa) with code obfuscation |
| `npm run build:ios` | `flutter build ios --flavor prod --obfuscate --split-debug-info=build/symbols` | Builds production iOS bundle with code obfuscation |

### Code Generation & Assets

| Script | Command | Description |
|---|---|---|
| `npm run codegen` | `dart run tool/codegen.dart` | Executes full generation pipeline: `pub get` → `build_runner` → `l10n` |
| `npm run build-runner` | `dart run build_runner build` | Runs `build_runner` for Freezed, Riverpod, Drift, and JSON |
| `npm run watch` | `dart run build_runner watch` | Watches files and re-runs code generation on change |
| `npm run l10n` | `flutter gen-l10n` | Generates localization delegates from `.arb` files |
| `npm run icons` | `dart run flutter_launcher_icons` | Generates Android adaptive and iOS application launcher icons |
| `npm run splash` | `dart run flutter_native_splash:create` | Generates Android and iOS native splash screens |

### Code Quality & Testing

| Script | Command | Description |
|---|---|---|
| `npm test` | `flutter test` | Executes all unit and widget tests |
| `npm run test:coverage` | `flutter test --coverage` | Executes tests and generates code coverage report (`coverage/lcov.info`) |
| `npm run test:integration` | `flutter test integration_test/app_test.dart` | Runs end-to-end integration test suite |
| `npm run lint` | `flutter analyze` | Runs static analysis and linter checks across the codebase |
| `npm run analyze` | `flutter analyze` | Alias for `lint` |
| `npm run format` | `dart format .` | Formats all Dart source files according to style guidelines |
| `npm run format:fix` | `dart format --fix .` | Formats files and applies automated fixable lint suggestions |
| `npm run check` | `npm run format && npm run analyze && npm test` | Complete pre-commit pipeline: formats, lints, and tests |

### Project Hygiene & Scaffolding

| Script | Command | Description |
|---|---|---|
| `npm run get` | `flutter pub get` | Downloads and updates project dependencies |
| `npm run clean` | `flutter clean` | Deletes build outputs and cached compiler artifacts |
| `npm run clean:get` | `flutter clean && flutter pub get` | Cleans build cache and re-downloads dependencies |
| `npm run fresh` | `flutter clean && flutter pub get && dart run tool/codegen.dart` | Complete project reset and full code regeneration |
| `npm run sync` | `dart run tool/sync.dart` | Full pipeline: `clean` → `pub get` → `codegen` → `analyze` → `test` |
| `npm run feature <name>` | `dart run tool/new_feature.dart <name>` | Scaffolds standard feature module structure (`data`, `model`, `controller`, `view`) |
| `npm run rename <pkg> "<Name>" <android_id> [ios_id]` | `dart run tool/rename_project.dart ...` | Renames project identifiers across Android, iOS, `.env`, Dart imports, and `package.json` |

