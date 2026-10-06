// ignore_for_file: avoid_print

import 'dart:io';

/// Cross-platform Dart script for renaming the project package name, bundle identifier, and display name.
/// Usage: `dart run tool/rename_project.dart <package_name> <bundle_id> "<App Name>"`
/// Example: `dart run tool/rename_project.dart my_awesome_app com.company.awesomeapp "My Awesome App"`
void main(List<String> args) {
  if (args.length < 3) {
    print('Usage: dart run tool/rename_project.dart <package_name> <bundle_id> "<App Name>"');
    print('Example: dart run tool/rename_project.dart my_app com.mycompany.myapp "My App"');
    exit(1);
  }

  final newPkg = args[0].trim();
  final newBundleId = args[1].trim();
  final newAppName = args[2].trim();

  const oldPkg = 'flutter_template';
  const oldBundleId = 'com.example.flutter_template';

  // Validate package_name
  if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(newPkg)) {
    stderr.writeln('Error: package_name must be valid lowercase snake_case (e.g. "my_awesome_app").');
    exit(1);
  }

  // Validate bundle_id
  if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)+$').hasMatch(newBundleId)) {
    stderr.writeln('Error: bundle_id must follow reverse-domain format (e.g. "com.example.myapp").');
    exit(1);
  }

  print('=================================================================');
  print('                Flutter Template Renaming Utility               ');
  print('=================================================================');
  print('Package Name : $oldPkg -> $newPkg');
  print('Bundle ID    : $oldBundleId -> $newBundleId');
  print('App Name     : $newAppName');
  print('=================================================================');
  stdout.write('Are you sure you want to proceed? [y/N] ');
  final input = stdin.readLineSync()?.trim().toLowerCase();
  if (input != 'y' && input != 'yes') {
    print('Renaming aborted.');
    exit(0);
  }

  // 1. Update pubspec.yaml
  print('\n==> [1/5] Updating pubspec.yaml...');
  _replaceInFile('pubspec.yaml', 'name: $oldPkg', 'name: $newPkg');

  // 2. Update imports across lib/, test/, and integration_test/
  print('==> [2/5] Updating Dart imports across lib/, test/, and integration_test/...');
  for (final dirPath in ['lib', 'test', 'integration_test']) {
    final dir = Directory(dirPath);
    if (!dir.existsSync()) continue;
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        _replaceInFile(entity.path, 'package:$oldPkg/', 'package:$newPkg/');
      }
    }
  }

  // 3. Update Android configuration
  print('==> [3/5] Updating Android configuration...');
  const androidGradle = 'android/app/build.gradle.kts';
  if (File(androidGradle).existsSync()) {
    _replaceInFile(androidGradle, 'applicationId = "$oldBundleId"', 'applicationId = "$newBundleId"');
    _replaceInFile(androidGradle, '"Flutter Template (Dev)"', '"$newAppName (Dev)"');
    _replaceInFile(androidGradle, '"Flutter Template (Staging)"', '"$newAppName (Staging)"');
    _replaceInFile(androidGradle, '"Flutter Template"', '"$newAppName"');
  }

  // 4. Update iOS configuration
  print('==> [4/5] Updating iOS configuration...');
  final iosDir = Directory('ios');
  if (iosDir.existsSync()) {
    for (final entity in iosDir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('project.pbxproj')) {
        var content = entity.readAsStringSync();
        content = content.replaceAll(RegExp(r'PRODUCT_BUNDLE_IDENTIFIER = [^;]+;'), 'PRODUCT_BUNDLE_IDENTIFIER = $newBundleId;');
        entity.writeAsStringSync(content);
      }
    }

    _replaceInFile('ios/Flutter/Dev.xcconfig', 'APP_DISPLAY_NAME=App (Dev)', 'APP_DISPLAY_NAME=$newAppName (Dev)');
    _replaceInFile('ios/Flutter/Staging.xcconfig', 'APP_DISPLAY_NAME=App (Staging)', 'APP_DISPLAY_NAME=$newAppName (Staging)');
    _replaceInFile('ios/Flutter/Prod.xcconfig', 'APP_DISPLAY_NAME=App', 'APP_DISPLAY_NAME=$newAppName');
  }

  // 5. Update .env files
  print('==> [5/5] Updating .env files...');
  for (final envName in ['.env.dev', '.env.staging', '.env.prod', '.env.example', '.env.prod.example']) {
    final envFile = File(envName);
    if (envFile.existsSync()) {
      var content = envFile.readAsStringSync();
      content = content.replaceAll(RegExp(r'^APP_NAME=.*$', multiLine: true), 'APP_NAME=$newAppName');
      envFile.writeAsStringSync(content);
    }
  }

  print('\n=================================================================');
  print('Project successfully renamed!');
  print('=================================================================');
  print('Follow-up commands to complete synchronization:');
  print('  1. flutter pub get');
  print('  2. dart run tool/codegen.dart');
  print('  3. flutter test');
  print('=================================================================');
}

void _replaceInFile(String filePath, String from, String to) {
  final file = File(filePath);
  if (!file.existsSync()) return;
  final content = file.readAsStringSync();
  if (content.contains(from)) {
    file.writeAsStringSync(content.replaceAll(from, to));
  }
}
