// ignore_for_file: avoid_print

import 'dart:io';

const Set<String> _skippedDirNames = {'build', '.dart_tool', '.gradle', 'Pods', '.git', 'node_modules', '.idea'};

const Set<String> _binaryExtensions = {
  '.png', '.jpg', '.jpeg', '.gif', '.ico', '.webp', '.svgz',
  '.zip', '.tar', '.gz', '.jar', '.aar', '.class', '.so', '.dylib', '.a',
  '.pdf', '.mp3', '.mp4', '.wav', '.ttf', '.otf', '.woff', '.woff2',
  // Logs (for example build_runner.log) are output, not source.
  '.log',
};

const Set<String> _dartReservedKeywords = {
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'base',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'covariant',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'false',
  'final',
  'finally',
  'for',
  'Function',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'null',
  'of',
  'on',
  'operator',
  'part',
  'required',
  'rethrow',
  'return',
  'sealed',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'typedef',
  'var',
  'void',
  'when',
  'while',
  'with',
  'yield',
};

/// Cross-platform Dart script for renaming the project package name, bundle identifier, and display name.
/// Usage: `dart run tool/rename_project.dart <package_name> "<App Name>" <android_id> [ios_bundle_id] [--yes] [--dry-run] [--force]`
void main(List<String> args) {
  final flags = <String>{};
  final positional = <String>[];

  for (final arg in args) {
    if (arg.startsWith('--')) {
      flags.add(arg);
    } else {
      positional.add(arg);
    }
  }

  final dryRun = flags.contains('--dry-run');
  final yes = flags.contains('--yes');
  final force = flags.contains('--force');

  if (positional.length < 3) {
    print('Usage: dart run tool/rename_project.dart <package_name> "<App Name>" <android_id> [ios_bundle_id] [--yes] [--dry-run] [--force]');
    print('Example: dart run tool/rename_project.dart my_app "My App" com.mycompany.myapp');
    print('Example (distinct IDs): dart run tool/rename_project.dart my_app "My App" com.mycompany.android com.mycompany.ios');
    print('Flags:');
    print('  --dry-run : Simulate changes and report what would be updated without writing files.');
    print('  --yes     : Non-interactive mode, bypasses the confirmation prompt.');
    print('  --force   : Run even if Git working tree has uncommitted changes.');
    exit(1);
  }

  final newPkg = positional[0].trim();
  final newAppName = positional[1].trim();
  final newAndroidId = positional[2].trim();
  final newIosId = positional.length >= 4 ? positional[3].trim() : newAndroidId;

  // Validate package_name
  if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(newPkg)) {
    stderr.writeln('Error: package_name must be valid lowercase snake_case (e.g. "my_awesome_app").');
    exit(1);
  }

  if (_dartReservedKeywords.contains(newPkg)) {
    stderr.writeln('Error: package_name "$newPkg" is a reserved Dart keyword.');
    exit(1);
  }

  // Validate app_name
  if (newAppName.isEmpty) {
    stderr.writeln('Error: app_name must not be empty.');
    exit(1);
  }

  final bundleIdRegex = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)+$');

  // Validate android_id
  if (!bundleIdRegex.hasMatch(newAndroidId)) {
    stderr.writeln('Error: android_id must follow reverse-domain format (e.g. "com.example.myapp").');
    exit(1);
  }

  // Validate ios_bundle_id
  if (!bundleIdRegex.hasMatch(newIosId)) {
    stderr.writeln('Error: ios_bundle_id must follow reverse-domain format (e.g. "com.example.myapp").');
    exit(1);
  }

  // Detect OLD values
  final oldPkg = _detectOldPackage();
  final oldAndroidId = _detectOldAndroidId();
  final oldIosId = _detectOldIosId();
  final oldAppName = _detectOldAppName();

  if (oldPkg == newPkg && oldAppName == newAppName && oldAndroidId == newAndroidId && oldIosId == newIosId) {
    print('Nothing to do: project is already configured with these identifiers.');
    exit(0);
  }

  // Safety: Git status check. A dry run writes nothing, so it is always allowed.
  if (!force && !dryRun) {
    try {
      final gitRes = Process.runSync('git', ['status', '--porcelain']);
      if (gitRes.exitCode == 0 && (gitRes.stdout as String).trim().isNotEmpty) {
        stderr.writeln('Error: Git working tree has uncommitted changes.');
        stderr.writeln('Commit or stash changes before renaming, or pass --force to bypass this check.');
        exit(1);
      }
    } on ProcessException {
      // Git not installed or not in PATH; skip check
    }
  }

  print('=================================================================');
  print('                Flutter Template Renaming Utility               ');
  print('=================================================================');
  print('Package Name : $oldPkg -> $newPkg');
  print('App Name     : $oldAppName -> $newAppName');
  if (newAndroidId == newIosId) {
    print('Bundle ID    : $oldAndroidId -> $newAndroidId (Android & iOS)');
  } else {
    print('Android ID   : $oldAndroidId -> $newAndroidId');
    print('iOS Bundle ID: $oldIosId -> $newIosId');
  }
  if (dryRun) {
    print('Mode         : DRY RUN (no files will be written)');
  }
  print('=================================================================');

  if (!dryRun && !yes) {
    stdout.write('Are you sure you want to proceed? [y/N] ');
    final input = stdin.readLineSync()?.trim().toLowerCase();
    if (input != 'y' && input != 'yes') {
      print('Renaming aborted.');
      exit(0);
    }
  }

  // 1. Update pubspec.yaml
  _applyFileChange('pubspec.yaml', dryRun, (content) {
    return content.replaceFirst(RegExp(r'^name:\s*' + RegExp.escape(oldPkg), multiLine: true), 'name: $newPkg');
  });

  // 2. Update Dart imports across lib/, test/, integration_test/, and tool/*.dart
  for (final dirPath in ['lib', 'test', 'integration_test', 'tool']) {
    final dir = Directory(dirPath);
    if (!dir.existsSync()) continue;
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        // Exclude tool/rename_project.dart itself from code template rewrites
        if (_normalizePath(entity.path) == 'tool/rename_project.dart') continue;
        _applyFileChange(entity.path, dryRun, (content) {
          return content.replaceAll('package:$oldPkg/', 'package:$newPkg/');
        });
      }
    }
  }

  // 3. Update Android configuration (build.gradle.kts)
  // Only the quoted values are replaced; every other line in a flavor block
  // (signingConfig, versionNameSuffix, ...) is left untouched.
  const androidGradle = 'android/app/build.gradle.kts';
  if (File(androidGradle).existsSync()) {
    _applyFileChange(androidGradle, dryRun, (content) {
      var updated = content;
      updated = updated.replaceAll('namespace = "$oldAndroidId"', 'namespace = "$newAndroidId"');
      updated = updated.replaceAll('applicationId = "$oldAndroidId"', 'applicationId = "$newAndroidId"');
      updated = _swapFlavorLabel(updated, 'dev', '$newAppName (Dev)');
      updated = _swapFlavorLabel(updated, 'staging', '$newAppName (Staging)');
      updated = _swapFlavorLabel(updated, 'prod', newAppName);
      return updated;
    });
  }

  // 4. Update Android Kotlin/Java source sets (move MainActivity and fix package)
  _processAndroidSourceSets(oldAndroidId, newAndroidId, dryRun);

  // 5. Update iOS configuration (project.pbxproj, xcconfig, Info.plist)
  final iosDir = Directory('ios');
  if (iosDir.existsSync()) {
    for (final entity in iosDir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('project.pbxproj')) {
        _applyFileChange(entity.path, dryRun, (content) {
          var updated = content;
          updated = updated.replaceAll('$oldIosId.RunnerTests', '$newIosId.RunnerTests');
          updated = updated.replaceAll(oldIosId, newIosId);
          return updated;
        });
      }
    }

    _applyFileChange('ios/Flutter/Dev.xcconfig', dryRun, (content) {
      return content.replaceAll(RegExp(r'^APP_DISPLAY_NAME=.*$', multiLine: true), 'APP_DISPLAY_NAME=$newAppName (Dev)');
    });
    _applyFileChange('ios/Flutter/Staging.xcconfig', dryRun, (content) {
      return content.replaceAll(RegExp(r'^APP_DISPLAY_NAME=.*$', multiLine: true), 'APP_DISPLAY_NAME=$newAppName (Staging)');
    });
    _applyFileChange('ios/Flutter/Prod.xcconfig', dryRun, (content) {
      return content.replaceAll(RegExp(r'^APP_DISPLAY_NAME=.*$', multiLine: true), 'APP_DISPLAY_NAME=$newAppName');
    });

    // CFBundleDisplayName uses the literal name because Dev/Staging/Prod.xcconfig
    // are not yet wired to build configurations in project.pbxproj.
    //
    // NOTE: String.replaceAll does NOT interpret $1 / ${1} group references
    // (the replacement is literal), so replaceAllMapped is required here.
    const infoPlist = 'ios/Runner/Info.plist';
    if (File(infoPlist).existsSync()) {
      _applyFileChange(infoPlist, dryRun, (content) {
        var updated = content;
        updated = updated.replaceAllMapped(RegExp(r'(<key>CFBundleDisplayName</key>\s*<string>)[^<]*(</string>)'), (m) => '${m[1]}$newAppName${m[2]}');
        updated = updated.replaceAllMapped(RegExp(r'(<key>CFBundleName</key>\s*<string>)[^<]*(</string>)'), (m) => '${m[1]}$newPkg${m[2]}');
        return updated;
      });
    }
  }

  // 6. Update .env files
  final envFiles = [
    ('.env.dev', '$newAppName (Dev)'),
    ('.env.example', '$newAppName (Dev)'),
    ('.env.staging', '$newAppName (Staging)'),
    ('.env.prod', newAppName),
    ('.env.prod.example', newAppName),
  ];

  for (final (fileName, envAppName) in envFiles) {
    if (File(fileName).existsSync()) {
      _applyFileChange(fileName, dryRun, (content) {
        return content.replaceAll(RegExp(r'^APP_NAME=.*$', multiLine: true), 'APP_NAME=$envAppName');
      });
    }
  }

  // Handle .env.local if present
  if (File('.env.local').existsSync()) {
    _applyFileChange('.env.local', dryRun, (content) {
      return content.replaceAll(RegExp(r'^APP_NAME=.*$', multiLine: true), 'APP_NAME=$newAppName');
    });
  }

  // 7. Update package.json
  const packageJson = 'package.json';
  if (File(packageJson).existsSync()) {
    _applyFileChange(packageJson, dryRun, (content) {
      final npmName = newPkg.replaceAll('_', '-');
      var updated = content;
      updated = updated.replaceAll(RegExp(r'"name":\s*"[^"]*"'), '"name": "$npmName"');
      updated = updated.replaceAll(RegExp(r'"description":\s*"[^"]*"'), '"description": "Script shortcuts for $newAppName"');
      return updated;
    });
  }

  if (dryRun) {
    print('\n=================================================================');
    print('[DRY RUN] Simulation complete. No files were modified or moved.');
    print('=================================================================');
    exit(0);
  }

  print('\n=================================================================');
  print('Project successfully renamed!');
  print('=================================================================');

  // 8. Final verification: check for leftover references
  print('==> Running final verification for leftover old identifiers...');
  final hasErrors = _verifyLeftovers(oldPkg, oldAndroidId, oldIosId);

  print('\nFollow-up commands to complete synchronization:');
  print('  1. flutter clean');
  print('  2. flutter pub get');
  print('  3. dart run tool/codegen.dart');
  print('  4. flutter analyze');
  print('  5. flutter test');
  print('=================================================================');

  if (hasErrors) {
    stderr.writeln('\nError: Leftover old identifiers detected in source files. See output above.');
    exit(2);
  }
}

/// Replaces only the quoted `app_name` value of one product flavor.
String _swapFlavorLabel(String source, String flavor, String label) {
  return source.replaceAllMapped(RegExp('(create\\("$flavor"\\)\\s*\\{[^}]*resValue\\("string",\\s*"app_name",\\s*")[^"]*(")'), (m) => '${m[1]}$label${m[2]}');
}

String _detectOldPackage() {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    stderr.writeln('Error: pubspec.yaml not found.');
    exit(1);
  }
  final match = RegExp(r'^name:\s*(\S+)', multiLine: true).firstMatch(pubspec.readAsStringSync());
  if (match == null) {
    stderr.writeln('Error: Could not detect package name from pubspec.yaml.');
    exit(1);
  }
  return match.group(1)!;
}

String _detectOldAndroidId() {
  final gradle = File('android/app/build.gradle.kts');
  if (!gradle.existsSync()) {
    stderr.writeln('Error: android/app/build.gradle.kts not found.');
    exit(1);
  }
  final content = gradle.readAsStringSync();
  final nsMatch = RegExp(r'namespace\s*=\s*"([^"]+)"').firstMatch(content);
  if (nsMatch != null) return nsMatch.group(1)!;

  final appIdMatch = RegExp(r'applicationId\s*=\s*"([^"]+)"').firstMatch(content);
  if (appIdMatch != null) return appIdMatch.group(1)!;

  stderr.writeln('Error: Could not detect Android namespace or applicationId in android/app/build.gradle.kts.');
  exit(1);
}

String _detectOldIosId() {
  final pbx = File('ios/Runner.xcodeproj/project.pbxproj');
  if (!pbx.existsSync()) {
    stderr.writeln('Error: ios/Runner.xcodeproj/project.pbxproj not found.');
    exit(1);
  }
  final content = pbx.readAsStringSync();
  for (final match in RegExp(r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*([^;]+);').allMatches(content)) {
    final candidate = match.group(1)!.trim();
    if (!candidate.endsWith('.RunnerTests')) {
      return candidate;
    }
  }
  stderr.writeln('Error: Could not detect iOS PRODUCT_BUNDLE_IDENTIFIER in ios/Runner.xcodeproj/project.pbxproj.');
  exit(1);
}

String _detectOldAppName() {
  final gradle = File('android/app/build.gradle.kts');
  if (gradle.existsSync()) {
    final content = gradle.readAsStringSync();
    final prodMatch = RegExp(r'create\("prod"\)\s*\{[^}]*resValue\("string",\s*"app_name",\s*"([^"]+)"\)', multiLine: true).firstMatch(content);
    if (prodMatch != null) return prodMatch.group(1)!;
  }
  final prodXcconfig = File('ios/Flutter/Prod.xcconfig');
  if (prodXcconfig.existsSync()) {
    final match = RegExp(r'^APP_DISPLAY_NAME=([^\r\n]+)', multiLine: true).firstMatch(prodXcconfig.readAsStringSync());
    if (match != null) return match.group(1)!.trim();
  }
  stderr.writeln('Error: Could not detect current app display name.');
  exit(1);
}

void _applyFileChange(String filePath, bool dryRun, String Function(String) transform) {
  final file = File(filePath);
  if (!file.existsSync()) return;
  final original = file.readAsStringSync();
  final updated = transform(original);
  if (original != updated) {
    if (dryRun) {
      print('[DRY RUN] Would update: $filePath');
    } else {
      file.writeAsStringSync(updated);
      print('Updated: $filePath');
    }
  }
}

void _processAndroidSourceSets(String oldAndroidId, String newAndroidId, bool dryRun) {
  final srcDir = Directory('android/app/src');
  if (!srcDir.existsSync()) return;

  final oldPathSuffix = oldAndroidId.replaceAll('.', '/');
  final newPathSuffix = newAndroidId.replaceAll('.', '/');

  final dirsToClean = <Directory>{};

  for (final entity in srcDir.listSync(recursive: true)) {
    if (entity is File) {
      final normPath = _normalizePath(entity.path);
      final isCodeFile = normPath.endsWith('.kt') || normPath.endsWith('.java');
      if (!isCodeFile) continue;

      if (normPath.contains(oldPathSuffix)) {
        final content = entity.readAsStringSync();
        final updated = content.replaceAll('package $oldAndroidId', 'package $newAndroidId').replaceAll('import $oldAndroidId.', 'import $newAndroidId.');

        final newNormPath = normPath.replaceAll(oldPathSuffix, newPathSuffix);
        final newFile = File(newNormPath.replaceAll('/', Platform.pathSeparator));

        if (dryRun) {
          print('[DRY RUN] Would move: ${entity.path} -> ${newFile.path}');
          if (content != updated) {
            print('[DRY RUN] Would update package declaration in: ${newFile.path}');
          }
        } else {
          newFile.parent.createSync(recursive: true);
          newFile.writeAsStringSync(updated);
          entity.deleteSync();
          print('Moved: ${entity.path} -> ${newFile.path}');
          dirsToClean.add(entity.parent);
        }
      }
    }
  }

  if (!dryRun) {
    for (final dir in dirsToClean) {
      _cleanEmptyDirs(dir);
    }
  }
}

void _cleanEmptyDirs(Directory dir) {
  if (!dir.existsSync()) return;
  try {
    final list = dir.listSync();
    if (list.isEmpty) {
      final parent = dir.parent;
      dir.deleteSync();
      _cleanEmptyDirs(parent);
    }
  } catch (_) {
    // Ignore permission or OS directory locking issues
  }
}

bool _verifyLeftovers(String oldPkg, String oldAndroidId, String oldIosId) {
  var hasErrors = false;
  final root = Directory('.');

  for (final file in _walkTextFiles(root)) {
    final normPath = _normalizePath(file.path);
    // Ignore the rename script itself
    if (normPath == 'tool/rename_project.dart') continue;

    final isMarkdownDoc = normPath == 'README.md' || normPath == 'CHANGELOG.md';

    List<String> lines;
    try {
      lines = file.readAsLinesSync();
    } catch (_) {
      continue;
    }

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final containsOldPkg = line.contains(oldPkg);
      final containsOldAndroid = line.contains(oldAndroidId);
      final containsOldIos = line.contains(oldIosId);

      if (containsOldPkg || containsOldAndroid || containsOldIos) {
        final location = '$normPath:${i + 1}: ${line.trim()}';
        if (isMarkdownDoc) {
          print('[WARNING] Leftover in documentation: $location');
        } else {
          stderr.writeln('[ERROR] Leftover in source: $location');
          hasErrors = true;
        }
      }
    }
  }

  return hasErrors;
}

Iterable<File> _walkTextFiles(Directory dir) sync* {
  List<FileSystemEntity> entities;
  try {
    entities = dir.listSync(recursive: false);
  } catch (_) {
    return;
  }

  for (final entity in entities) {
    // Last non-empty path segment, independent of '/' vs '\' and trailing slashes.
    final segments = entity.path.split(RegExp(r'[\\/]')).where((s) => s.isNotEmpty);
    final name = segments.isEmpty ? '' : segments.last;

    if (entity is Directory) {
      if (_skippedDirNames.contains(name)) continue;
      yield* _walkTextFiles(entity);
    } else if (entity is File) {
      final lower = entity.path.toLowerCase();
      if (!_binaryExtensions.any(lower.endsWith)) {
        yield entity;
      }
    }
  }
}

String _normalizePath(String path) {
  var p = path.replaceAll('\\', '/');
  if (p.startsWith('./')) {
    p = p.substring(2);
  }
  return p;
}
