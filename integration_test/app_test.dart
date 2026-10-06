import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_template/app/app.dart';
import 'package:flutter_template/core/database/app_database_provider.dart';
import 'package:flutter_template/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_template/shared/providers/shared_prefs_provider.dart';
import 'package:flutter_template/shared/widgets/buttons/primary_button.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test/helpers/mocks.dart';
import '../test/helpers/test_database.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockAuthRepository;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    // Explicit bootstrap-independent setup using Flavor.dev (appFlavor is null in tests)
    if (!dotenv.isInitialized) {
      dotenv.testLoad(
        fileInput:
            'FLAVOR=dev\nAPP_NAME=Flutter Template (Dev)\nBASE_URL=https://api.dev.example.com\nENABLE_LOGGING=true\nCONNECT_TIMEOUT_MS=15000\n',
      );
    }

    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    mockAuthRepository = MockAuthRepository();

    when(() => mockAuthRepository.restoreSession())
        .thenAnswer((_) async => null);
    when(() => mockAuthRepository.login('test@example.com', 'password123'))
        .thenAnswer((_) async => TestFixtures.testUser);
  });

  testWidgets('full flow: login, create item, navigate to settings, toggle theme', (tester) async {
    final testDb = createTestDatabase();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPrefsProvider.overrideWithValue(sharedPreferences),
          appDatabaseProvider.overrideWithValue(testDb),
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Login screen is displayed
    final loginButton = find.byType(PrimaryButton);
    expect(loginButton, findsOneWidget);

    // 2. Perform login
    final textFields = find.byType(TextField);
    expect(textFields, findsNWidgets(2));
    await tester.enterText(textFields.at(0), 'test@example.com');
    await tester.enterText(textFields.at(1), 'password123');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // 3. Verify navigated to Example List screen
    expect(find.text('Example'), findsWidgets);
    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);

    // 4. Add an example item via modal bottom sheet
    await tester.tap(fab);
    await tester.pumpAndSettle();

    final formFields = find.byType(TextField);
    await tester.enterText(formFields.at(0), 'Integration Item');
    await tester.enterText(formFields.at(1), 'Created via integration test');

    final saveButton = find.widgetWithText(PrimaryButton, 'Add');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Integration Item'), findsOneWidget);

    // 5. Navigate to Settings tab
    final settingsTab = find.byIcon(Icons.settings_outlined);
    expect(settingsTab, findsOneWidget);
    await tester.tap(settingsTab);
    await tester.pumpAndSettle();

    // 6. Verify Settings screen and toggle Dark Mode
    expect(find.text('Theme'), findsOneWidget);
    final darkThemeSegment = find.text('Dark Mode');
    expect(darkThemeSegment, findsOneWidget);
    await tester.tap(darkThemeSegment);
    await tester.pumpAndSettle();

    await testDb.close();
  });
}
